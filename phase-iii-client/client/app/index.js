import React from 'react';
import { render } from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import registerServiceWorker from './registerServiceWorker';
import App from './App';
import './app.global.css';
import './scss/index.global.scss';

render(
  <BrowserRouter>
    <App />
  </BrowserRouter>,
  document.getElementById('root')
);
registerServiceWorker();
