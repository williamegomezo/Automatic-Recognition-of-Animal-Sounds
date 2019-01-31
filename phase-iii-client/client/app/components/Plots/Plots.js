// @flow
import React, { Component } from 'react';
import Paper from '@material-ui/core/Paper';
import FormControl from '@material-ui/core/FormControl';
import VariableSelect from './VariableSelect';

class Plots extends Component {
  render() {
    const { headers, data } = this.props;
    return (
      <FormControl className="row col-xs-24">
        <Paper className="col-xs-4" elevation={1}>
          <VariableSelect
            title="Select X:"
            model="variable_x"
            options={headers}
          />
        </Paper>
        <Paper className="col-xs-off-1 col-xs-4" elevation={1}>
          <VariableSelect
            title="Select Y:"
            model="variable_y"
            options={headers}
          />
        </Paper>
        <Paper className="col-xs-off-1 col-xs-12" elevation={1} />
      </FormControl>
    );
  }
}

export default Plots;
