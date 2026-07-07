import { createServer } from 'node:http';
import { readFile, stat } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const previewDir = path.dirname(__filename);
const repoRoot = path.resolve(previewDir, '..', '..');
const skinMediaDir = path.join(repoRoot, 'resources', 'skins', 'Main', 'media');
const templatesDir = path.join(repoRoot, 'resources', 'skins', 'Main', '1080i', 'templates');

const MIME_TYPES = new Map([
  ['.html', 'text/html; charset=utf-8'],
  ['.css', 'text/css; charset=utf-8'],
  ['.js', 'text/javascript; charset=utf-8'],
  ['.json', 'application/json; charset=utf-8'],
  ['.png', 'image/png'],
  ['.jpg', 'image/jpeg'],
  ['.jpeg', 'image/jpeg'],
  ['.gif', 'image/gif'],
  ['.svg', 'image/svg+xml'],
  ['.txt', 'text/plain; charset=utf-8'],
  ['.tpl', 'text/plain; charset=utf-8'],
]);

const templateFiles = [
  'script-plex-home.xml.tpl',
  'includes/hub_itemlayout_poster.xml.tpl',
  'includes/hub_focusedlayout_poster.xml.tpl',
  'includes/hub_itemlayout_square.xml.tpl',
  'includes/hub_focusedlayout_square.xml.tpl',
  'includes/hub_itemlayout_ar16x9.xml.tpl',
  'includes/hub_focusedlayout_ar16x9.xml.tpl',
  'default.xml.tpl',
  'base.xml.tpl',
];

function send(res, status, body, type = 'text/plain; charset=utf-8') {
  res.writeHead(status, {
    'Content-Type': type,
    'Cache-Control': 'no-store',
  });
  res.end(body);
}

function safeJoin(base, requestPath) {
  const decodedPath = decodeURIComponent(requestPath);
  const resolved = path.resolve(base, decodedPath.replace(/^\/+/, ''));
  if (!resolved.startsWith(base + path.sep) && resolved !== base) {
    return null;
  }
  return resolved;
}

async function sendFile(res, filePath) {
  try {
    const info = await stat(filePath);
    if (!info.isFile()) {
      send(res, 404, 'Not found');
      return;
    }

    const ext = path.extname(filePath);
    const body = await readFile(filePath);
    send(res, 200, body, MIME_TYPES.get(ext) || 'application/octet-stream');
  } catch (error) {
    if (error && error.code === 'ENOENT') {
      send(res, 404, 'Not found');
      return;
    }
    send(res, 500, `Server error: ${error.message}`);
  }
}

async function readTemplateSummary(file) {
  const filePath = safeJoin(templatesDir, file);
  if (!filePath) {
    return null;
  }
  const text = await readFile(filePath, 'utf8');
  const lines = text.split(/\r?\n/);
  return {
    file,
    path: path.relative(repoRoot, filePath),
    lineCount: lines.length,
    excerpt: lines.slice(0, 80).join('\n'),
  };
}

async function handleApi(req, res, url) {
  if (url.pathname === '/api/templates') {
    const summaries = await Promise.all(templateFiles.map(readTemplateSummary));
    send(res, 200, JSON.stringify({ templates: summaries.filter(Boolean) }, null, 2), 'application/json; charset=utf-8');
    return true;
  }

  if (url.pathname.startsWith('/api/template/')) {
    const file = url.pathname.replace('/api/template/', '');
    const filePath = safeJoin(templatesDir, file);
    if (!filePath) {
      send(res, 400, 'Invalid template path');
      return true;
    }
    await sendFile(res, filePath);
    return true;
  }

  return false;
}

const server = createServer(async (req, res) => {
  try {
    const url = new URL(req.url || '/', 'http://127.0.0.1');

    if (await handleApi(req, res, url)) {
      return;
    }

    if (url.pathname.startsWith('/skin-media/')) {
      const filePath = safeJoin(skinMediaDir, url.pathname.replace('/skin-media/', ''));
      if (!filePath) {
        send(res, 400, 'Invalid media path');
        return;
      }
      await sendFile(res, filePath);
      return;
    }

    const requestPath = url.pathname === '/' ? '/index.html' : url.pathname;
    const filePath = safeJoin(previewDir, requestPath);
    if (!filePath) {
      send(res, 400, 'Invalid path');
      return;
    }
    await sendFile(res, filePath);
  } catch (error) {
    send(res, 500, `Server error: ${error.message}`);
  }
});

const preferredPort = Number(process.env.PORT || 5178);
let port = preferredPort;

function listen(nextPort) {
  server.listen(nextPort, '127.0.0.1');
}

server.on('error', (error) => {
  if (error.code === 'EADDRINUSE' && port < preferredPort + 20) {
    port += 1;
    listen(port);
    return;
  }
  throw error;
});

server.on('listening', () => {
  const address = server.address();
  console.log(`Kodi UI preview running at http://127.0.0.1:${address.port}/`);
});

listen(port);
