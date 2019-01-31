// @flow
import React, { Component } from 'react';
import SwipeableViews from 'react-swipeable-views';
import AppBar from '@material-ui/core/AppBar';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';
import CustomTable from '../components/CustomTable/CustomTable';
import CallDisplay from '../components/CallDisplay/CallDisplay';
import Plots from '../components/Plots/Plots';
import callButtons from '../constants/CallDisplayButtons.json';
import mockResults from '../mocks/Results.json';
import clusterResults from '../mocks/Clusters.json';

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
              <Tab label="Cluster results" />
              <Tab label="Representative Calls" />
              <Tab label="Plots" />
              <Tab label="Activity Patterns" />
            </Tabs>
          </AppBar>
          <SwipeableViews
            index={this.state.value}
            onChangeIndex={this.handleChangeIndex}
          >
            <div className="row col-xs-24">
              <div className="col-xs-16">
                <CustomTable
                  moduleType="results_table"
                  headers={mockResults.headers}
                  data={mockResults.data}
                  checkbox
                />
              </div>
              <div className="col-xs-8">
                <CallDisplay
                  moduleType="results_table"
                  headers={mockResults.headers}
                  buttons={callButtons}
                />
              </div>
            </div>
            <div className="row col-xs-24">
              <div className="col-xs-16">
                <CustomTable
                  moduleType="cluster_table"
                  headers={clusterResults.headers}
                  data={clusterResults.data}
                />
              </div>
              <div className="col-xs-8">
                <CallDisplay
                  moduleType="cluster_table"
                  headers={clusterResults.headers}
                  buttons={callButtons}
                />
              </div>
            </div>
            <div className="row col-xs-24">
              <Plots headers={mockResults.headers} data={mockResults.data} />
            </div>
          </SwipeableViews>
        </div>
      </div>
    );
  }
}
