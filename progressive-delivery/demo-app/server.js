'use strict';

const http = require('http');
const os = require('os');

const PORT = parseInt(process.env.PORT || '8080', 10);
const APP_VERSION = process.env.APP_VERSION || '1.0.0';
const APP_COLOR = process.env.APP_COLOR || 'blue';
const SERVICE_NAME = 'progressive-delivery-demo';

console.log(`Starting ${SERVICE_NAME} version=${APP_VERSION} color=${APP_COLOR} pid=${process.pid}`);

// --- Metrics state ---
const requestCounts = {};   // key: `${status}|${service}` -> count
const durationBuckets = {}; // key: `${service}|${le}` -> count
const durationSum = {};     // key: service -> sum seconds
const durationCount = {};   // key: service -> count

const HISTOGRAM_BUCKETS = [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10];

function recordRequest(status, service, durationSec) {
  const countKey = `${status}|${service}`;
  requestCounts[countKey] = (requestCounts[countKey] || 0) + 1;

  durationSum[service] = (durationSum[service] || 0) + durationSec;
  durationCount[service] = (durationCount[service] || 0) + 1;

  for (const le of HISTOGRAM_BUCKETS) {
    const bKey = `${service}|${le}`;
    if (durationSec <= le) {
      durationBuckets[bKey] = (durationBuckets[bKey] || 0) + 1;
    }
  }
  // +Inf bucket
  const infKey = `${service}|+Inf`;
  durationBuckets[infKey] = (durationBuckets[infKey] || 0) + 1;
}

function buildMetrics() {
  const lines = [];

  // http_requests_total
  lines.push('# HELP http_requests_total Total HTTP requests by status and service');
  lines.push('# TYPE http_requests_total counter');
  for (const key of Object.keys(requestCounts)) {
    const [status, service] = key.split('|');
    lines.push(`http_requests_total{status="${status}",service="${service}"} ${requestCounts[key]}`);
  }

  // http_request_duration_seconds
  lines.push('# HELP http_request_duration_seconds HTTP request duration in seconds');
  lines.push('# TYPE http_request_duration_seconds histogram');
  const services = [...new Set(Object.keys(durationCount))];
  for (const service of services) {
    for (const le of HISTOGRAM_BUCKETS) {
      const bKey = `${service}|${le}`;
      const val = durationBuckets[bKey] || 0;
      lines.push(`http_request_duration_seconds_bucket{service="${service}",le="${le}"} ${val}`);
    }
    const infKey = `${service}|+Inf`;
    lines.push(`http_request_duration_seconds_bucket{service="${service}",le="+Inf"} ${durationBuckets[infKey] || 0}`);
    lines.push(`http_request_duration_seconds_sum{service="${service}"} ${(durationSum[service] || 0).toFixed(6)}`);
    lines.push(`http_request_duration_seconds_count{service="${service}"} ${durationCount[service] || 0}`);
  }

  return lines.join('\n') + '\n';
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

const server = http.createServer(async (req, res) => {
  const start = Date.now();

  // 20% random 500 for any endpoint (simulates errors for analysis testing)
  const forceError = Math.random() < 0.2;

  let status = 200;
  let body = '';
  let contentType = 'application/json';

  try {
    if (req.url === '/healthz') {
      // Health check is never forced to 500
      body = JSON.stringify({ status: 'ok' });
    } else if (req.url === '/metrics') {
      // Metrics endpoint never forced to 500
      contentType = 'text/plain; version=0.0.4; charset=utf-8';
      body = buildMetrics();
    } else if (req.url === '/slow') {
      const delay = 200 + Math.floor(Math.random() * 600); // 200-800ms
      await sleep(delay);
      if (forceError) {
        status = 500;
        body = JSON.stringify({ error: 'internal server error' });
      } else {
        body = JSON.stringify({
          service: SERVICE_NAME,
          version: APP_VERSION,
          color: APP_COLOR,
          hostname: os.hostname(),
          delay_ms: delay,
        });
      }
    } else {
      // GET /
      if (forceError) {
        status = 500;
        body = JSON.stringify({ error: 'internal server error' });
      } else {
        body = JSON.stringify({
          service: SERVICE_NAME,
          version: APP_VERSION,
          hostname: os.hostname(),
          color: APP_COLOR,
        });
      }
    }
  } catch (err) {
    status = 500;
    body = JSON.stringify({ error: String(err) });
  }

  const durationSec = (Date.now() - start) / 1000;

  // Record metrics (skip /metrics and /healthz from counters to keep noise low)
  if (req.url !== '/metrics' && req.url !== '/healthz') {
    recordRequest(String(status), SERVICE_NAME, durationSec);
  }

  res.writeHead(status, {
    'Content-Type': contentType,
    'Content-Length': Buffer.byteLength(body),
  });
  res.end(body);
});

server.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});

process.on('SIGTERM', () => {
  console.log('Received SIGTERM, shutting down gracefully');
  server.close(() => process.exit(0));
});
