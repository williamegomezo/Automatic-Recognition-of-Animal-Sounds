// @flow
import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';
import Divider from '@material-ui/core/Divider';
import Paper from '@material-ui/core/Paper';
import { remote } from 'electron';
import CustomList from './CustomList';

export default class Home extends Component {
  selectDirectory = () => {
    remote.dialog.showOpenDialog(
      {
        properties: ['openDirectory']
      },
      filePaths => {
        console.log(filePaths);
      }
    );
  };

  render() {
    return (
      <div data-tid="container">
        <h2>Aureas</h2>
        <div className="row">
          <div className="col-xs-offset-1 col-xs-10">
            <span>Species</span>
            <CustomList />
          </div>
          <div className="col-xs-offset-2 col-xs-10">
            <span>Folder</span>
            <CustomList />
            <Paper>
              <List>
                <ListItem>
                  <ListItemText primary="Photos" secondary="Jan 9, 2014" />
                </ListItem>
                <Divider component="li" />
                <ListItem>
                  <ListItemText primary="Photos" secondary="Jan 9, 2014" />
                </ListItem>
                <Divider component="li" />
              </List>
            </Paper>
          </div>
        </div>
        <Button
          variant="contained"
          color="primary"
          onClick={this.selectDirectory}
        >
          Hello World
        </Button>
      </div>
    );
  }
}
