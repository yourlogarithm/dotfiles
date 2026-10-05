'use strict';

// herdr-radar render hook: append the model a Claude pane runs to its sidebar
// title ("Sentry errors · Opus 5.5"). Herdr's agent list carries no model, so
// ~/.claude/statusline.sh writes it to <state>/herdr-model/<pane id> on every
// statusline render; this reads it back. Loaded once per radar daemon start.

const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

const dir = path.join(process.env.XDG_STATE_HOME || path.join(os.homedir(), '.local', 'state'), 'herdr-model');

// Radar calls agent() right before title() for the same pane. Remembering the
// vendor keeps a pane id reused by a non-Claude agent from showing a stale model.
const vendors = new Map();

function model(pane) {
  try {
    return fs.readFileSync(path.join(dir, pane), 'utf8').trim();
  } catch {
    return '';
  }
}

module.exports = {
  agent(name, pane) {
    vendors.set(pane, name);
    return name;
  },
  title(text, pane) {
    if (vendors.get(pane) !== 'claude') return text;
    const m = model(pane);
    return m ? `${text} · ${m}` : text;
  },
};
