// @flow
import React, { Component } from 'react';
import SwipeableViews from 'react-swipeable-views';
import AppBar from '@material-ui/core/AppBar';
import Fab from '@material-ui/core/Fab';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';
import Tooltip from '@material-ui/core/Tooltip';
import ArrowBack from '@material-ui/icons/ArrowBack';
import CustomTable from '../components/CustomTable/CustomTable';
import CallDisplay from '../components/CallDisplay/CallDisplay';
import Plots from '../components/Plots/Plots';
import ActivityPatterns from '../components/ActivityPatterns/ActivityPatterns';
import Alert from '../components/Alert/Alert';
import callButtons from '../constants/CallDisplayButtons.json';
import routes from '../constants/routes.json';

class TableView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: 0,
      openDialog: false,
      results: props.history.location.state.results,
      clusters: props.history.location.state.clusters,
      model: props.history.location.state.results.model
    };
  }

  handleChange = (event, value) => {
    this.setState({ value });
  };

  handleChangeIndex = index => {
    this.setState({ value: index });
  };

  handleGoBack = () => {
    this.setState({ openDialog: true });
  };

  render() {
    return (
      <div className="row col-xs-24">
        <div className="row col-xs-2 center-xs">
          <Tooltip title={'Initial screen'}>
            <Fab>
              <ArrowBack onClick={this.handleGoBack} />
            </Fab>
          </Tooltip>
        </div>
        <div className="row col-xs-22">
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
                  headers={this.state.results.headers}
                  data={this.state.results.data}
                  model={this.state.model}
                  checkbox
                />
              </div>
              <div className="col-xs-8">
                <CallDisplay
                  moduleType="results_table"
                  headers={this.state.results.headers}
                  buttons={callButtons}
                />
              </div>
            </div>
            <div className="row col-xs-24">
              <div className="col-xs-16">
                <CustomTable
                  moduleType="cluster_table"
                  headers={this.state.clusters.headers}
                  data={this.state.clusters.data}
                />
              </div>
              <div className="col-xs-8">
                <CallDisplay
                  moduleType="cluster_table"
                  headers={this.state.clusters.headers}
                  buttons={callButtons}
                />
              </div>
            </div>
            <div className="row col-xs-24 plots__container">
              <Plots
                headers={this.state.results.headers}
                data={this.state.results.data}
                clusters={this.state.clusters.data}
              />
            </div>
            <div className="row col-xs-24">
              <ActivityPatterns
                data={this.state.results.data}
                clusters={this.state.clusters.data}
              />
            </div>
          </SwipeableViews>
        </div>
        <Alert
          open={this.state.openDialog}
          title="Warning!"
          content="You are returning to the initial screen, the results will be erased. Do you want to continue?"
          firstButtonText="No"
          firstButtonCallback={() => {}}
          secondButtonText="Yes"
          secondButtonCallback={() => {
            this.props.history.push(routes.HOME);
          }}
        />
      </div>
    );
  }
}

export default TableView;
