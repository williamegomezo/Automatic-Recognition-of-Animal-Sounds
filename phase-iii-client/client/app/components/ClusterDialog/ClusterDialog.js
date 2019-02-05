import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import LinearProgress from '@material-ui/core/LinearProgress';
import FormControl from '@material-ui/core/FormControl';
import FormHelperText from '@material-ui/core/FormHelperText';
import Input from '@material-ui/core/Input';
import InputLabel from '@material-ui/core/InputLabel';
import { getData } from '../../utils/promises';

class ClusterDialog extends Component {
  state = {
    open: this.props.open,
    requestInProgress: false,
    name: '',
    error: false,
    errorMsg: ''
  };

  handleClickOpen = () => {
    this.setState({ open: true });
  };

  handleClose = action => {
    if (action === 'CANCEL') {
      this.setState({ open: false });
      this.setState({ requestInProgress: false });
    }
    if (action === 'CREATE') {
      const { selected, model } = this.props;
      const { name } = this.state;
      this.setState({ requestInProgress: true }, () => {
        getData('save-cluster', 'POST', {
          selected,
          model,
          name
        }).then(console.log);
      });
    }
  };

  handleChange = event => {
    this.setState({ name: event.target.value });
  };

  componentWillReceiveProps(nextProps) {
    this.setState({ open: nextProps.open });
  }

  render() {
    return (
      <Dialog
        open={this.state.open}
        onClose={this.handleClose}
        aria-labelledby="form-dialog-title"
      >
        <DialogTitle id="form-dialog-title">
          Create a species cluster
        </DialogTitle>
        <DialogContent>
          <DialogContentText>Write the species name</DialogContentText>
          <FormControl error={this.state.error}>
            <InputLabel htmlFor="component-error">Cluster name</InputLabel>
            <Input
              id="component-error"
              value={this.state.name}
              onChange={this.handleChange}
              aria-describedby="component-error-text"
            />
            {this.state.errorMsg && (
              <FormHelperText id="component-error-text">
                {this.state.errorMsg}
              </FormHelperText>
            )}
          </FormControl>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => this.handleClose('CANCEL')} color="primary">
            Cancel
          </Button>
          <Button onClick={() => this.handleClose('CREATE')} color="primary">
            Create
          </Button>
        </DialogActions>
        {this.state.requestInProgress && <LinearProgress />}
      </Dialog>
    );
  }
}

export default ClusterDialog;
