/* eslint-env browser */
/* global PIAZZA_URL COURSE_TITLE ABOUT_URL CANVAS_URL */
// pull in desired CSS/SASS files

// eslint-disable-next-line import/no-unresolved
require('ace-css/css/ace.css');

require('./styles/main.scss');


// Inject bundled Elm app into div#main
// eslint-disable-next-line import/no-unresolved
const Elm = require('../elm/Main.elm');
const initElmPorts = require('./elm-ports.js')
    .default;

// See https://github.com/elm/browser/blob/1.0.0/notes/navigation-in-elements.md
const app = Elm.Main.init({
    flags: {
        courseTitle: COURSE_TITLE,
        piazzaURL: PIAZZA_URL,
        aboutURL: ABOUT_URL,
        canvasURL: CANVAS_URL,
        // eslint-disable-next-line no-restricted-globals
        location: location.href,
    },
    node: document.getElementById('main'),
});

// Inform app o
initElmPorts(app);
