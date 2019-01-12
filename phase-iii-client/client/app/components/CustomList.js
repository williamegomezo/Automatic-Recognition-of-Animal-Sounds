// @flow
import React, { Component } from 'react';
import List from '@material-ui/core/List';
import Fab from '@material-ui/core/Fab';
import Paper from '@material-ui/core/Paper';
import TextField from '@material-ui/core/TextField';
import IconButton from '@material-ui/core/IconButton';
import Tooltip from '@material-ui/core/Tooltip';
import AddIcon from '@material-ui/icons/Add';
import SearchIcon from '@material-ui/icons/Search';
import CustomListItem from './CustomListItem';

export default class CustomList extends Component {
  render() {
    return (
      <div style={styles.container}>
        <div
          style={styles.searchBar}
          className="row col-xs-24 middle-xs center-xs"
        >
          <div className="col-offset-1 col-xs-17">
            <TextField label="Search" style={styles.searchInput} />
          </div>
          <div className="col-xs-4">
            <IconButton aria-label="Search">
              <SearchIcon />
            </IconButton>
          </div>
        </div>
        <Paper>
          <List style={styles.list}>
            <CustomListItem primary="Audio 1" />
            <CustomListItem primary="Audio 2" />
            <CustomListItem primary="Audio 1" />
            <CustomListItem primary="Audio 2" />
            <CustomListItem primary="Audio 1" />
            <CustomListItem primary="Audio 2" />
          </List>
        </Paper>
        <Tooltip title="Add audio">
          <Fab style={styles.listFloatButton}>
            <AddIcon />
          </Fab>
        </Tooltip>
      </div>
    );
  }
}

const styles = {
  container: {
    position: 'relative'
  },
  searchBar: {
    padding: '10px'
  },
  searchInput: {
    width: '100%'
  },
  list: {
    padding: '15px 10px 30px',
    maxHeight: '200px',
    overflow: 'auto'
  },
  listFloatButton: {
    bottom: '15px',
    position: 'absolute',
    right: '15px'
  }
};
