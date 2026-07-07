const ASSET_BASE = '/skin-media/script.plex';

const sections = [
  { label: 'Home', icon: 'home/type/home.png', home: true },
  { label: 'Movies', icon: 'home/type/movie.png' },
  { label: 'TV Shows', icon: 'home/type/show.png' },
  { label: 'Music', icon: 'home/type/artist.png' },
  { label: 'Photos', icon: 'home/type/photo.png' },
  { label: 'Watchlist', icon: 'home/type/watchlist.png' },
  { label: 'Playlists', icon: 'home/type/playlists.png' },
];

const posterItems = [
  { label: 'Dune: Part Two', sub: 'Continue watching', progress: 67, art: poster('dune') },
  { label: 'Severance', sub: 'S02 E04', progress: 31, art: poster('severance') },
  { label: 'Blade Runner 2049', sub: 'Recently added', progress: 0, art: poster('blade') },
  { label: 'The Bear', sub: 'Next episode', progress: 0, art: poster('bear') },
  { label: 'Alien', sub: 'Top unwatched', progress: 0, art: poster('alien') },
  { label: 'Arrival', sub: 'Watchlisted', progress: 0, art: poster('arrival') },
  { label: 'More', end: true },
];

const squareItems = [
  { label: 'Mezzanine', sub: 'Massive Attack', art: square('mezzanine') },
  { label: 'Random Access Memories', sub: 'Daft Punk', art: square('ram') },
  { label: 'In Rainbows', sub: 'Radiohead', art: square('rainbows') },
  { label: 'Blue Train', sub: 'John Coltrane', art: square('blue') },
  { label: 'Untrue', sub: 'Burial', art: square('untrue') },
  { label: 'More', end: true },
];

const landscapeItems = [
  { label: 'Foundation', sub: 'S03 E01', progress: 20, art: landscape('foundation') },
  { label: 'The Last of Us', sub: 'S02 E03', progress: 54, art: landscape('lastofus') },
  { label: 'Planet Earth', sub: 'A fresh start', progress: 0, art: landscape('earth') },
  { label: 'Slow Horses', sub: 'Up next', progress: 0, art: landscape('horses') },
  { label: 'More', end: true },
];

const hubs = [
  { title: 'Continue Watching', display: 'poster', items: posterItems },
  { title: 'Recently Added Movies', display: 'poster', items: posterItems.slice(2).concat(posterItems.slice(0, 2)) },
  { title: 'Recently Added Episodes', display: 'ar16x9', items: landscapeItems },
  { title: 'Recently Played Music', display: 'square', items: squareItems },
];

const stage = document.querySelector('#kodi-stage');
const stageShell = document.querySelector('#stage-shell');
const sectionStrip = document.querySelector('.section-strip');
const hubStack = document.querySelector('.hub-stack');
const sourceList = document.querySelector('#source-list');
const sourceExcerpt = document.querySelector('#source-excerpt');

renderSections();
renderHubs();
bindToolbar();
loadTemplates();
setScale('fit');
window.addEventListener('resize', () => {
  if (document.querySelector('[data-scale="fit"]').classList.contains('is-active')) {
    setScale('fit');
  }
});

function renderSections() {
  sectionStrip.innerHTML = '';
  sections.forEach((section, index) => {
    const item = document.createElement('button');
    item.type = 'button';
    item.className = `section-item is-focusable${index === 0 ? ' is-selected' : ''}`;
    item.innerHTML = `
      <span class="section-card">
        <img src="${ASSET_BASE}/${section.icon}" alt="">
      </span>
      <span>${section.label}</span>
    `;
    sectionStrip.appendChild(item);
  });
}

function renderHubs() {
  hubStack.innerHTML = '';
  hubs.forEach((hub, hubIndex) => {
    const row = document.createElement('section');
    row.className = `hub-row hub-${hub.display}`;
    row.dataset.display = hub.display;
    row.innerHTML = `
      <div class="bifurcation-line" aria-hidden="true"></div>
      <h2>${hub.title}</h2>
      <div class="hub-list" role="list"></div>
    `;
    const list = row.querySelector('.hub-list');
    hub.items.forEach((item, itemIndex) => list.appendChild(renderCard(item, hub.display, hubIndex === 0 && itemIndex === 0)));
    hubStack.appendChild(row);
  });
}

function renderCard(item, display, focused) {
  const card = document.createElement('article');
  card.className = `media-card media-${display} is-focusable${focused ? ' is-focused' : ''}${item.end ? ' is-end' : ''}`;
  card.tabIndex = 0;

  if (item.end) {
    card.innerHTML = `
      <div class="art-frame more-frame">
        <img src="${ASSET_BASE}/indicators/chevron-white.png" alt="">
      </div>
      <h3>${item.label}</h3>
    `;
    return card;
  }

  card.innerHTML = `
    <div class="art-frame">
      <img src="${item.art}" alt="">
      ${item.progress ? `<div class="progress-track"><span style="width:${item.progress}%"></span></div>` : ''}
      <span class="watched-dot" aria-hidden="true"></span>
    </div>
    <h3>${item.label}</h3>
    <p>${item.sub || ''}</p>
  `;
  return card;
}

function bindToolbar() {
  document.querySelectorAll('[data-scale]').forEach((button) => {
    button.addEventListener('click', () => setScale(button.dataset.scale));
  });

  document.querySelector('#toggle-lines').addEventListener('click', (event) => {
    const next = stage.dataset.lines !== 'true';
    stage.dataset.lines = String(next);
    event.currentTarget.classList.toggle('is-active', next);
  });

  document.querySelector('#toggle-bg').addEventListener('click', (event) => {
    const next = stage.dataset.art !== 'true';
    stage.dataset.art = String(next);
    event.currentTarget.classList.toggle('is-active', next);
  });
}

function setScale(value) {
  document.querySelectorAll('[data-scale]').forEach((button) => {
    button.classList.toggle('is-active', button.dataset.scale === value);
  });

  let scale = 1;
  if (value === 'fit') {
    const previewPanel = document.querySelector('.preview-panel');
    const toolbar = document.querySelector('.preview-toolbar');
    const panelRect = previewPanel.getBoundingClientRect();
    const toolbarRect = toolbar.getBoundingClientRect();
    const compact = window.matchMedia('(max-width: 1120px)').matches;
    const horizontalMargin = compact ? 16 : 36;
    const verticalMargin = compact ? 24 : 36;
    const availableWidth = panelRect.width - horizontalMargin;
    const availableHeight = Math.max(360, panelRect.height - toolbarRect.height - verticalMargin);
    scale = Math.min(availableWidth / 1920, availableHeight / 1080, 1);
  } else {
    scale = Number(value) / 100;
  }

  stage.style.setProperty('--preview-scale', String(scale));
  stageShell.style.setProperty('--stage-width', `${1920 * scale}px`);
  stageShell.style.setProperty('--stage-height', `${1080 * scale}px`);
}

async function loadTemplates() {
  try {
    const response = await fetch('/api/templates');
    const data = await response.json();
    renderTemplateList(data.templates);
  } catch (error) {
    sourceExcerpt.textContent = `Could not load templates: ${error.message}`;
  }
}

function renderTemplateList(templates) {
  sourceList.innerHTML = '';
  templates.forEach((template, index) => {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = `source-button${index === 0 ? ' is-active' : ''}`;
    button.textContent = template.file;
    button.addEventListener('click', () => {
      document.querySelectorAll('.source-button').forEach((item) => item.classList.remove('is-active'));
      button.classList.add('is-active');
      sourceExcerpt.textContent = `${template.path}\n${'-'.repeat(template.path.length)}\n${template.excerpt}`;
    });
    sourceList.appendChild(button);
  });

  if (templates[0]) {
    sourceExcerpt.textContent = `${templates[0].path}\n${'-'.repeat(templates[0].path.length)}\n${templates[0].excerpt}`;
  }
}

function poster(seed) {
  return mockArt(seed, 488, 722);
}

function square(seed) {
  return mockArt(seed, 420, 420);
}

function landscape(seed) {
  return mockArt(seed, 640, 360);
}

function mockArt(seed, width, height) {
  const palettes = [
    ['#3b2f2f', '#d39848', '#f1d7a7'],
    ['#1b2d3d', '#5ba2d0', '#d7eef4'],
    ['#251d34', '#8e6ac8', '#e9d9ff'],
    ['#173224', '#72a86e', '#d7e6c8'],
    ['#342118', '#c4633a', '#f3c9a9'],
    ['#20242d', '#a7b0ca', '#eef1f6'],
  ];
  const hash = Array.from(seed).reduce((value, char) => value + char.charCodeAt(0), 0);
  const [base, accent, light] = palettes[hash % palettes.length];
  const wide = width > height;
  const radius = Math.round(Math.min(width, height) * 0.26);
  const svg = `
    <svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
      <defs>
        <linearGradient id="g" x1="0" x2="1" y1="0" y2="1">
          <stop offset="0" stop-color="${base}"/>
          <stop offset="0.58" stop-color="${accent}"/>
          <stop offset="1" stop-color="${light}"/>
        </linearGradient>
      </defs>
      <rect width="${width}" height="${height}" fill="url(#g)"/>
      <circle cx="${Math.round(width * 0.18)}" cy="${Math.round(height * 0.18)}" r="${radius}" fill="rgba(255,255,255,0.16)"/>
      <circle cx="${Math.round(width * 0.78)}" cy="${Math.round(height * 0.34)}" r="${Math.round(radius * 0.72)}" fill="rgba(0,0,0,0.18)"/>
      <path d="M0 ${Math.round(height * 0.72)} C ${Math.round(width * 0.28)} ${Math.round(height * (wide ? 0.55 : 0.62))}, ${Math.round(width * 0.56)} ${Math.round(height * 0.9)}, ${width} ${Math.round(height * 0.66)} L ${width} ${height} L 0 ${height} Z" fill="rgba(0,0,0,0.22)"/>
      <rect x="${Math.round(width * 0.08)}" y="${Math.round(height * 0.08)}" width="${Math.round(width * 0.84)}" height="${Math.round(height * 0.84)}" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="${Math.max(3, Math.round(width * 0.01))}"/>
    </svg>
  `;
  return `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}`;
}
