// @flow
import React, { Component } from 'react';
import Divider from '@material-ui/core/Divider';

export default class VerticalDivider extends Component {
  render() {
    return <Divider className={styles.divider} />;
  }
}

const styles = {
  divider: {
    width: 1,
    height: 28
  }
};
