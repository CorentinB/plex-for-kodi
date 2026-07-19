const ASSET_BASE = '/skin-media/script.plex';

const sections = [
  { label: 'Accueil', icon: 'buttons/home.png', selected: true },
  { label: 'Watchlist', icon: 'home/type/watchlist.png' },
  { label: 'Listes de lecture', icon: 'home/type/playlists.png' },
  { label: 'Movies', icon: 'home/type/movie.png' },
  { label: 'TV Shows', icon: 'home/type/show.png' },
  { label: 'Audiobooks', icon: 'home/type/artist.png' },
];

const hero = {
  title: 'the CONNERS',
  rating: 'TV-PG',
  year: '2018',
  duration: '30m',
  genre: 'Comedy',
  summary: 'Follow-up to the comedy series Roseanne, centering on the family members of the matriarch after her sudden death.',
  cast: 'John Goodman, Laurie Metcalf, Sara Gilbert, Alicia Goranson',
  art: heroArt('The Conners'),
};

const posterItems = [
  { label: 'The Conners', sub: 'S7 • E6', rating: 'TV-PG', year: '2018', duration: '30m', genre: 'Comedy', summary: hero.summary, cast: hero.cast, progress: 0, art: poster('conners', 'The Conners') },
  { label: 'Mayfair Witches', sub: 'S2 • E4', rating: 'TV-14', year: '2025', duration: '48m', genre: 'Drama', summary: 'A gifted neurosurgeon discovers that she is the unlikely heir to a family of witches.', progress: 0, art: poster('mayfair', 'Mayfair Witches') },
  { label: 'The Drew Carey Show', sub: 'S4 • E2', rating: 'TV-PG', year: '1998', duration: '22m', genre: 'Comedy', summary: 'Work, friendship, and Cleveland collide in a sharp ensemble comedy.', progress: 0, art: poster('drew', 'Drew Carey') },
  { label: 'Discovery of Witches', sub: 'S3 • E1', rating: 'TV-14', year: '2022', duration: '46m', genre: 'Fantasy', summary: 'A historian and a vampire unravel a manuscript tied to the origin of magical creatures.', progress: 0, art: poster('witches', 'Discovery') },
  { label: 'Weeds', sub: 'S8 • E12', rating: 'TV-MA', year: '2012', duration: '28m', genre: 'Comedy', summary: 'A suburban family keeps reinventing itself while old choices catch up with them.', progress: 0, art: poster('weeds', 'Weeds') },
  { label: 'Spartacus', sub: 'S3 • E10', rating: 'TV-MA', year: '2013', duration: '55m', genre: 'Drama', summary: 'A rebel army makes its final stand against Rome.', progress: 0, art: poster('spartacus', 'Spartacus') },
  { label: 'Baby Driver', sub: '2017', rating: 'R', year: '2017', duration: '1h 53m', genre: 'Action', summary: 'A gifted getaway driver tries to leave crime behind after meeting the woman of his dreams.', progress: 0, art: poster('driver', 'Baby Driver') },
  { label: 'More', end: true },
];

const recentPosterItems = [
  { label: 'No Home Movie', sub: '2015', rating: 'NR', year: '2015', duration: '1h 55m', genre: 'Documentary', summary: 'An intimate portrait built from conversations, distance, and the texture of everyday life.', art: poster('home-movie', 'No Home Movie') },
  { label: 'Kingdom of Heaven', sub: '2005', rating: 'R', year: '2005', duration: '3h 14m', genre: 'Drama', summary: 'A blacksmith becomes a defender of Jerusalem during the Crusades.', art: poster('kingdom', 'Kingdom of Heaven') },
  { label: 'Léon', sub: '1994', rating: 'R', year: '1994', duration: '2h 13m', genre: 'Thriller', summary: 'A solitary hitman becomes the reluctant guardian of a young girl.', art: poster('leon', 'Léon') },
  ...posterItems.slice(1, 6),
];

const squareItems = [
  { label: 'Comedy Classics', sub: '68 titles', art: square('classics', 'Comedy') },
  { label: 'Family Sitcoms', sub: '42 titles', art: square('family', 'Family') },
  { label: 'Premium Drama', sub: '31 titles', art: square('drama', 'Drama') },
  { label: 'Weekend Queue', sub: '18 titles', art: square('queue', 'Queue') },
  { label: 'Recently Played', sub: '12 titles', art: square('played', 'Played') },
  { label: 'More', end: true },
];

const landscapeItems = [
  { label: 'Animal Control', sub: 'S02 E07', progress: 20, art: landscape('animal', 'Animal Control') },
  { label: 'Abbott Elementary', sub: 'S04 E02', progress: 54, art: landscape('abbott', 'Abbott') },
  { label: 'Ghosts', sub: 'S03 E10', progress: 0, art: landscape('ghosts', 'Ghosts') },
  { label: 'Shrinking', sub: 'Up next', progress: 0, art: landscape('shrinking', 'Shrinking') },
  { label: 'More', end: true },
];

const hubs = [
  { title: 'On Deck', display: 'poster', items: posterItems },
  { title: 'Recently Added Movies', display: 'poster', items: recentPosterItems },
  { title: 'Recently Added Music', display: 'square', items: squareItems },
  { title: 'Recently Added Videos', display: 'ar16x9', items: landscapeItems },
];

const stage = document.querySelector('#kodi-stage');
const stageShell = document.querySelector('#stage-shell');
const sectionStrip = document.querySelector('.section-strip');
const hubStack = document.querySelector('.hub-stack');
const sourceList = document.querySelector('#source-list');
const sourceExcerpt = document.querySelector('#source-excerpt');

renderHero();
renderSections();
renderHubs();
bindToolbar();
bindStageChrome();
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
    item.className = `section-item is-focusable${index === 0 ? ' is-home' : ''}${section.selected ? ' is-selected' : ''}`;
    item.innerHTML = `
      <img src="${ASSET_BASE}/${section.icon}" alt="">
      <span>${section.label}</span>
    `;
    item.addEventListener('focus', restoreTopComposition);
    item.addEventListener('click', () => {
      sections.forEach((entry) => { entry.selected = false; });
      section.selected = true;
      document.querySelectorAll('.section-item').forEach((entry) => entry.classList.remove('is-selected'));
      item.classList.add('is-selected');
    });
    item.addEventListener('keydown', (event) => moveSectionFocus(event, index));
    sectionStrip.appendChild(item);
  });
}

function renderHero(selection = hero) {
  const art = selection.heroArt || selection.art || hero.art;
  stage.style.setProperty('--hero-art', `url("${art}")`);
  document.querySelector('[data-hero-title]').textContent = selection.heroTitle || selection.label || selection.title || '';
  document.querySelector('[data-hero-meta]').textContent = [selection.rating, selection.year, selection.duration, selection.genre].filter(Boolean).join('    ');
  document.querySelector('[data-hero-summary]').textContent = selection.summary || '';
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
    hub.items.forEach((item, itemIndex) => list.appendChild(renderCard(item, hub.display, hubIndex, itemIndex, hubIndex === 0 && itemIndex === 0)));
    hubStack.appendChild(row);
  });
}

function renderCard(item, display, hubIndex, itemIndex, focused) {
  const card = document.createElement('article');
  card.className = `media-card media-${display} is-focusable${focused ? ' is-focused' : ''}${item.end ? ' is-end' : ''}`;
  card.tabIndex = 0;
  card.dataset.hubIndex = String(hubIndex);
  card.dataset.itemIndex = String(itemIndex);
  card.addEventListener('focus', () => selectCard(card, item, hubIndex));
  card.addEventListener('click', () => selectCard(card, item, hubIndex));
  card.addEventListener('keydown', handleCardKeydown);

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

function bindStageChrome() {
  document.querySelector('.rail-button').addEventListener('focus', restoreTopComposition);
}

function selectCard(card, item, hubIndex) {
  pinStageViewport();
  document.querySelectorAll('.media-card.is-focused').forEach((entry) => entry.classList.remove('is-focused'));
  card.classList.add('is-focused');
  stage.dataset.hubIndex = String(hubIndex);
  const shift = hubIndex === 0 ? 0 : -650 - ((hubIndex - 1) * 555);
  stage.style.setProperty('--hub-shift', `${shift}px`);
  stage.classList.toggle('is-scrolled', hubIndex > 0);
  if (!item.end) {
    renderHero({
      title: item.label,
      rating: item.rating || '',
      year: item.year || '',
      duration: item.duration || '',
      genre: item.genre || '',
      summary: item.summary || '',
      cast: item.cast || '',
      heroArt: heroArt(item.label),
    });
  }
}

function restoreTopComposition() {
  pinStageViewport();
  stage.dataset.hubIndex = '0';
  stage.style.setProperty('--hub-shift', '0px');
  stage.classList.remove('is-scrolled');
}

function pinStageViewport() {
  const reset = () => {
    stage.scrollTop = 0;
    stage.scrollLeft = 0;
    stageShell.scrollTop = 0;
    stageShell.scrollLeft = 0;
  };
  reset();
  requestAnimationFrame(reset);
}

function handleCardKeydown(event) {
  const hubIndex = Number(event.currentTarget.dataset.hubIndex);
  const itemIndex = Number(event.currentTarget.dataset.itemIndex);
  let nextHub = hubIndex;
  let nextItem = itemIndex;

  if (event.key === 'ArrowLeft') nextItem -= 1;
  else if (event.key === 'ArrowRight') nextItem += 1;
  else if (event.key === 'ArrowUp' && hubIndex === 0) {
    event.preventDefault();
    document.querySelector('.section-item.is-selected')?.focus({ preventScroll: true });
    return;
  } else if (event.key === 'ArrowUp') nextHub -= 1;
  else if (event.key === 'ArrowDown') nextHub += 1;
  else if (event.key === 'Escape') {
    event.preventDefault();
    document.querySelector('.section-item.is-selected')?.focus({ preventScroll: true });
    return;
  } else {
    return;
  }

  event.preventDefault();
  const rows = [...document.querySelectorAll('.hub-row')];
  nextHub = Math.max(0, Math.min(rows.length - 1, nextHub));
  const cards = [...rows[nextHub].querySelectorAll('.media-card')];
  nextItem = Math.max(0, Math.min(cards.length - 1, nextItem));
  cards[nextItem]?.focus({ preventScroll: true });
}

function moveSectionFocus(event, index) {
  if (!['ArrowLeft', 'ArrowRight', 'ArrowDown'].includes(event.key)) return;
  event.preventDefault();
  if (event.key === 'ArrowDown') {
    document.querySelector('.hub-row .media-card')?.focus({ preventScroll: true });
    return;
  }
  const items = [...document.querySelectorAll('.section-item')];
  const direction = event.key === 'ArrowLeft' ? -1 : 1;
  items[Math.max(0, Math.min(items.length - 1, index + direction))]?.focus({ preventScroll: true });
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

function poster(seed, label) {
  return mockArt(seed, 488, 722, label, 'poster');
}

function square(seed, label) {
  return mockArt(seed, 420, 420, label, 'square');
}

function landscape(seed, label) {
  return mockArt(seed, 640, 360, label, 'landscape');
}

function heroArt(seed) {
  const svg = `
    <svg xmlns="http://www.w3.org/2000/svg" width="1920" height="1080" viewBox="0 0 1920 1080">
      <defs>
        <linearGradient id="wall" x1="0" x2="1" y1="0" y2="1">
          <stop offset="0" stop-color="#6b2f25"/>
          <stop offset="0.48" stop-color="#a77745"/>
          <stop offset="1" stop-color="#d4bc89"/>
        </linearGradient>
        <radialGradient id="glow" cx="0.72" cy="0.42" r="0.6">
          <stop offset="0" stop-color="#f8dca6" stop-opacity="0.82"/>
          <stop offset="1" stop-color="#0f1915" stop-opacity="0"/>
        </radialGradient>
      </defs>
      <rect width="1920" height="1080" fill="url(#wall)"/>
      <rect x="1170" y="90" width="500" height="720" fill="#ead8b4" opacity="0.82"/>
      <rect x="1240" y="160" width="210" height="450" fill="#5f3d24" opacity="0.42"/>
      <rect x="840" y="455" width="330" height="260" fill="#9a6a3e"/>
      <rect x="840" y="455" width="330" height="24" fill="#cfa16b"/>
      <circle cx="760" cy="320" r="96" fill="#5b2f2f"/>
      <rect x="700" y="416" width="140" height="290" rx="50" fill="#492525"/>
      <circle cx="970" cy="292" r="82" fill="#3f2a2f"/>
      <rect x="910" y="374" width="140" height="340" rx="54" fill="#8d5843"/>
      <circle cx="1135" cy="330" r="80" fill="#3c2730"/>
      <rect x="1074" y="414" width="140" height="300" rx="50" fill="#5f2747"/>
      <circle cx="1438" cy="280" r="88" fill="#7b5030"/>
      <rect x="1362" y="372" width="165" height="358" rx="58" fill="#7a4b2b"/>
      <circle cx="1668" cy="330" r="78" fill="#8a6042"/>
      <rect x="1604" y="412" width="146" height="318" rx="54" fill="#a98163"/>
      <rect width="1920" height="1080" fill="url(#glow)"/>
      <rect width="1920" height="1080" fill="#000" opacity="0.22"/>
    </svg>
  `;
  return `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}`;
}

function mockArt(seed, width, height, label, shape) {
  const palettes = [
    ['#3e1518', '#d9a12e', '#f5dc75'],
    ['#15151d', '#8d5a35', '#f0d2a0'],
    ['#101b2e', '#326d9e', '#d4eef7'],
    ['#14291e', '#6ca65a', '#d8e7c5'],
    ['#23142f', '#7450ab', '#f0d9ff'],
    ['#171a20', '#b25336', '#f0c7a2'],
  ];
  const hash = Array.from(seed).reduce((value, char) => value + char.charCodeAt(0), 0);
  const [base, accent, light] = palettes[hash % palettes.length];
  const wide = width > height;
  const safeLabel = escapeXml(label || seed);
  const titleY = wide ? Math.round(height * 0.72) : Math.round(height * 0.82);
  const fontSize = wide ? 54 : shape === 'square' ? 46 : 48;
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
      <rect x="0" y="${Math.round(height * 0.66)}" width="${width}" height="${Math.round(height * 0.34)}" fill="rgba(0,0,0,0.42)"/>
      <text x="${Math.round(width * 0.5)}" y="${titleY}" fill="#fff" font-family="Arial, Helvetica, sans-serif" font-size="${fontSize}" font-weight="700" text-anchor="middle">${safeLabel}</text>
    </svg>
  `;
  return `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}`;
}

function escapeXml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
