// @flow
import React, { Component } from 'react';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';

class CustomPanel extends Component {
  render() {
    return (
      <List className="col-xs-24">
        <ListItem className="row col-xs-24">
          <ListItemText
            className="col-xs-12 center-xs"
            primary="Photos"
            secondary="Jan 9, 2014"
          />
          <ListItemText
            className="col-xs-12 center-xs"
            primary="Photos"
            secondary="Jan 9, 2014"
          />
        </ListItem>
        <ListItem className="row col-xs-24">
          <ListItemText
            className="col-xs-12 center-xs"
            primary="Photos"
            secondary="Jan 9, 2014"
          />
          <ListItemText
            className="col-xs-12 center-xs"
            primary="Photos"
            secondary="Jan 9, 2014"
          />
        </ListItem>
      </List>
    );
  }
}

export default CustomPanel;
