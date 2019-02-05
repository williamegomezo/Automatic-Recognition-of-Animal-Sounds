import React, { Component } from 'react';
import { withStyles } from '@material-ui/core/styles';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import Tooltip from '@material-ui/core/Tooltip';
import Add from '@material-ui/icons/Add';
import { lighten } from '@material-ui/core/styles/colorManipulator';
import ClusterDialog from './../ClusterDialog/ClusterDialog';

class CustomToolbar extends Component {
  state = {
    clusterDialogOpened: false
  };

  saveCluster = () => {
    this.setState({ clusterDialogOpened: true });
  };

  componentWillReceiveProps() {
    this.setState({ clusterDialogOpened: false });
  }

  render() {
    const { selected, classes, model } = this.props;
    const numSelected = selected.length;
    return (
      <Toolbar className={classes.root}>
        <div className={classes.title}>
          {numSelected > 0 ? (
            <Typography variant="h6" id="tableTitle">
              {numSelected} selected
            </Typography>
          ) : (
            <Typography variant="h6" id="tableTitle">
              Results:
            </Typography>
          )}
        </div>
        <div className={classes.spacer} />
        <div className={classes.actions}>
          {numSelected > 0 && (
            <Tooltip title="Create a species cluster">
              <IconButton aria-label="createCluster" onClick={this.saveCluster}>
                <Add />
              </IconButton>
            </Tooltip>
          )}
        </div>
        <ClusterDialog
          open={this.state.clusterDialogOpened}
          selected={selected}
          model={model}
        />
      </Toolbar>
    );
  }
}

const toolbarStyles = theme => ({
  root: {
    paddingRight: theme.spacing.unit
  },
  highlight:
    theme.palette.type === 'light'
      ? {
          color: theme.palette.secondary.main,
          backgroundColor: lighten(theme.palette.secondary.light, 0.85)
        }
      : {
          color: theme.palette.text.primary,
          backgroundColor: theme.palette.secondary.dark
        },
  spacer: {
    flex: '1 1 100%'
  },
  actions: {
    color: theme.palette.text.secondary
  },
  title: {
    flex: '0 0 auto'
  }
});

export default withStyles(toolbarStyles)(CustomToolbar);
