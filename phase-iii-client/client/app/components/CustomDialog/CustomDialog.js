// @flow
import React, { Component } from 'react';
import Dialog from '@material-ui/core/Dialog';
import CallDisplay from '../CallDisplay/CallDisplay';
import headers from '../../constants/CallDisplayHeaders';

export default class CustomDialog extends Component {
  render() {
    const { mode, open, handleClose } = this.props;
    return (
      <Dialog open={open} onClose={handleClose}>
        <div className="customDialog__container">
          <CallDisplay moduleType="list_initial" headers={headers} />
        </div>
      </Dialog>
    );
  }
}
