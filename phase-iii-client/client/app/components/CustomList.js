// @flow
import React, { Component } from 'react';
import List from '@material-ui/core/List';
import Fab from '@material-ui/core/Fab';
import TextField from '@material-ui/core/TextField';
import IconButton from '@material-ui/core/IconButton';
import Tooltip from '@material-ui/core/Tooltip';
import AddIcon from '@material-ui/icons/Add';
import SearchIcon from '@material-ui/icons/Search';
import { Link } from 'react-router-dom';
import CustomListItem from './CustomListItem';
import routes from '../constants/routes';

type Props = {
  dir: string,
  addButton: object,
  checkbox: boolean,
  buttons: array,
  items: array
};

export default class CustomList extends Component<Props> {
  props: Props;

  constructor(props) {
    const { items } = props;
    super(props);
    this.state = {
      searchValue: '',
      filteredItems: items
    };
    this.searchItems = this.searchItems.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    const { items } = this.props;
    if (nextProps.items !== items) {
      this.setState({ filteredItems: nextProps.items });
    }
  }

  searchItems(event) {
    this.setState({ searchValue: event.target.value }, () => {
      const { items } = this.props;
      const { searchValue } = this.state;
      this.setState({
        filteredItems: items
          ? items.filter(item => item.includes(searchValue))
          : []
      });
    });
  }

  render() {
    const { dir, addButton, buttons, checkbox } = this.props;
    const { filteredItems, searchValue } = this.state;
    return (
      <div style={styles.container}>
        <div
          style={styles.searchBar}
          className="row col-xs-24 middle-xs center-xs"
        >
          <div className="col-offset-1 col-xs-17">
            <TextField
              label="Search"
              style={styles.searchInput}
              value={searchValue}
              onChange={this.searchItems}
            />
          </div>
          <div className="col-xs-4">
            <IconButton aria-label="Search">
              <SearchIcon />
            </IconButton>
          </div>
        </div>
        <List style={styles.list}>
          {filteredItems.length === 0 && (
            <CustomListItem primary="No results. List empty." />
          )}
          {filteredItems.map(item => (
            <CustomListItem
              dir={dir}
              primary={item}
              checkbox={checkbox}
              buttons={buttons}
            />
          ))}
        </List>
        {addButton && (
          <Tooltip title={addButton.text}>
            <Link to={routes.TABLE}>
              <Fab style={styles.listFloatButton}>
                <AddIcon />
              </Fab>
            </Link>
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
