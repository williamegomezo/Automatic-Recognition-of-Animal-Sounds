import React, { Component } from 'react';
import { Switch, Route } from 'react-router-dom';
import HomePage from './containers/HomePage';
import TablePage from './containers/TablePage';
import routes from './constants/routes';

class App extends Component {
  render() {
    return (
      <Switch>
        <Route path={routes.TABLE} component={TablePage} />
        <Route path={routes.HOME} component={HomePage} />
      </Switch>
    );
  }
}

export default App;
