// @flow
import React, { Component } from 'react';
import List from '@material-ui/core/List';
import Fab from '@material-ui/core/Fab';
import TextField from '@material-ui/core/TextField';
import IconButton from '@material-ui/core/IconButton';
import Tooltip from '@material-ui/core/Tooltip';
import AddIcon from '@material-ui/icons/Add';
import SearchIcon from '@material-ui/icons/Search';
import CustomListItem from './CustomListItem';
import fileButtons from '../mocks/FileButtons.json';

type Props = {
  dir: string,
  addText: string,
  items: array
};

export default class CustomList extends Component<Props> {
  props: Props;

  render() {
    const { dir, items, addText } = this.props;
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
        <List style={styles.list}>
          {items.length === 0 && <CustomListItem primary="List Empty" />}
          {items.map(item => (
            <CustomListItem
              key={item}
              dir={dir}
              primary={item}
              checkbox
              buttons={fileButtons}
            />
          ))}
        </List>
        {addText && (
          <Tooltip title={addText}>
            <Fab style={styles.listFloatButton}>
              <AddIcon />
            </Fab>
          </Tooltip>
        )}
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
    height: '200px',
    overflow: 'auto'
  },
  listFloatButton: {
    bottom: '15px',
    position: 'absolute',
    right: '15px'
  }
};
