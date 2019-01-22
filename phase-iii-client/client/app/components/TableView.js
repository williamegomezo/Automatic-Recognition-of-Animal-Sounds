// @flow
import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import routes from '../constants/routes';

export default class TableView extends Component<Props> {
  props: Props;

  render() {
    return (
      <div>
        <div c data-tid="backButton">
          <Link to={routes.HOME}>
            <i className="fa fa-arrow-left fa-3x" />
          </Link>
          Results
        </div>
      </div>
    );
  }
}
