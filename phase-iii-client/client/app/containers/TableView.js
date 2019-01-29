// @flow
import React, { Component } from 'react';
import SwipeableViews from 'react-swipeable-views';
import AppBar from '@material-ui/core/AppBar';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';
import CustomTable from '../components/CustomTable/CustomTable';
import CallDisplay from '../components/CallDisplay/CallDisplay';

export default class TableView extends Component {
  state = {
    value: 0
  };

  handleChange = (event, value) => {
    this.setState({ value });
  };

  handleChangeIndex = index => {
    this.setState({ value: index });
  };

  render() {
    return (
      <div>
        <div>
          <AppBar position="static" color="default">
            <Tabs
              value={this.state.value}
              onChange={this.handleChange}
              indicatorColor="primary"
              textColor="primary"
              variant="fullWidth"
            >
              <Tab label="Item One" />
              <Tab label="Item Two" />
              <Tab label="Item Three" />
            </Tabs>
          </AppBar>
          <SwipeableViews
            index={this.state.value}
            onChangeIndex={this.handleChangeIndex}
          >
            <div className="row col-xs-24">
              <div className="col-xs-16">
                <CustomTable />
              </div>
              <div className="col-xs-8">
                <CallDisplay />
              </div>
            </div>
            <div>Item Two</div>
            <div>Item Three</div>
          </SwipeableViews>
        </div>
      </div>
    );
  }
}
