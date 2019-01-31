// @flow
import React, { Component } from 'react';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';

class CustomPanel extends Component {
  render() {
    const { info } = this.props;
    const chunks = [];
    for (let i = 0; i < info.length; i = i + 2) {
      chunks.push(info.slice(i, i + 2));
    }
    console.log(info, chunks);
    return (
      <List className="col-xs-24">
        {chunks.map((c, i) => {
          return (
            <ListItem key={i} className="row col-xs-24">
              {c.length > 0 && (
                <ListItemText
                  className="col-xs-12 center-xs"
                  primary={c[0]['label']}
                  secondary={c[0]['value']}
                />
              )}
              {c.length > 1 && (
                <ListItemText
                  className="col-xs-12 center-xs"
                  primary={c[1]['label']}
                  secondary={c[1]['value']}
                />
              )}
            </ListItem>
          );
        })}
      </List>
    );
  }
}

export default CustomPanel;
