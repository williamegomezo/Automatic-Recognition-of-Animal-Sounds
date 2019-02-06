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

class CustomList extends Component {
  constructor(props) {
    const { items, selectedSpecies } = props;
    super(props);
    this.state = {
      selected: [],
      searchValue: '',
      filteredItems: items.map((item, id) => ({
        id,
        text: item,
        checked: selectedSpecies ? selectedSpecies.includes(id) : false
      }))
    };
    this.searchItems = this.searchItems.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    const { items, selectedSpecies } = this.props;
    if (nextProps.items !== items) {
      this.setState({
        filteredItems: nextProps.items.map((item, id) => ({
          id,
          text: item,
          checked: selectedSpecies ? selectedSpecies.includes(id) : false
        }))
      });
    }
  }

  searchItems(event) {
    this.setState({ searchValue: event.target.value }, () => {
      const { selectedSpecies } = this.props;
      const items = this.props.items.map((item, id) => ({
        id,
        text: item,
        checked: selectedSpecies ? selectedSpecies.includes(id) : false
      }));
      const { searchValue } = this.state;
      this.setState({
        filteredItems: items
          ? items.filter(item => item.text.includes(searchValue))
          : []
      });
    });
  }

  render() {
    const { dir, addButton, buttons, checkbox, selectionChange } = this.props;
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
            <CustomListItem item={{ text: 'No results. List empty.' }} />
          )}
          {filteredItems.map((item, key) => (
            <CustomListItem
              id={item.id}
              key={key}
              dir={dir}
              item={item}
              checkbox={checkbox}
              buttons={buttons}
              selectionChange={selectionChange}
            />
          ))}
        </List>
        {addButton && (
          <Tooltip title={addButton.text}>
            <Fab onClick={addButton.callback} style={styles.listFloatButton}>
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

export default CustomList;
