/* eslint-env browser */
/* global PIAZZA_URL COURSE_TITLE */
// pull in desired CSS/SASS files

// eslint-disable-next-line import/no-unresolved
require('ace-css/css/ace.css');
// eslint-disable-next-line import/no-unresolved
require('font-awesome/css/font-awesome.css');
require('./styles/main.scss');


// Inject bundled Elm app into div#main
// eslint-disable-next-line import/no-unresolved
const Elm = require('../elm/Main');

Elm.Main.embed(document.getElementById('main'), {
    courseTitle: COURSE_TITLE,
    piazzaURL: PIAZZA_URL,
});
