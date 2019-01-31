import React from 'react';
import { render } from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import { AppContainer } from 'react-hot-loader';
import { Provider } from 'react-redux';
import store from './store';
import App from './App';
import './app.global.css';
import './scss/index.global.scss';

render(
  <Provider store={store}>
    <AppContainer>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </AppContainer>
  </Provider>,
  document.getElementById('root')
);

if (module.hot) {
  module.hot.accept('./App', () => {
    // eslint-disable-next-line global-require
    render(
      <Provider store={store}>
        <AppContainer>
          <BrowserRouter>
            <App />
          </BrowserRouter>
        </AppContainer>
      </Provider>,
      document.getElementById('root')
    );
  });
}
