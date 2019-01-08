// @flow
import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import Grid from '@material-ui/core/Grid';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import FolderIcon from '@material-ui/icons/Folder';
import { remote } from 'electron';

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
          <div className="col-xs-6">Hola</div>
          <div className="col-xs-6">Super</div>
        </div>
        <Button
          variant="contained"
          color="primary"
          onClick={this.selectDirectory}
        >
          Hello World
        </Button>

        <Grid item xs={12} md={6}>
          <div>
            <List className="fileList">
              <ListItem>
                <ListItemIcon>
                  <FolderIcon />
                </ListItemIcon>
                <ListItemText primary="Single-line item" />
              </ListItem>
              <ListItem>
                <ListItemIcon>
                  <FolderIcon />
                </ListItemIcon>
                <ListItemText primary="Single-line item" />
              </ListItem>
              <ListItem>
                <ListItemIcon>
                  <FolderIcon />
                </ListItemIcon>
                <ListItemText primary="Single-line item" />
              </ListItem>
            </List>
          </div>
        </Grid>
      </div>
    );
  }
}
