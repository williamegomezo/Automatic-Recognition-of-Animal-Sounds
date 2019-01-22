import React from 'react';
import { Switch, Route } from 'react-router';
import routes from './constants/routes';
import App from './containers/App';
import HomePage from './containers/HomePage';
import TablePage from './containers/TablePage';

export default () => (
  <App>
    <Switch>
      <Route path={routes.TABLE} component={TablePage} />
      <Route path={routes.HOME} component={HomePage} />
    </Switch>
  </App>
);
