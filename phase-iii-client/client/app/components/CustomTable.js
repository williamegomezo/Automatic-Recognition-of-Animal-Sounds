import React from 'react';
import { withStyles } from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TablePagination from '@material-ui/core/TablePagination';
import Paper from '@material-ui/core/Paper';
import CustomHeader from './ResultsTable/CustomHeader';
import CustomBody from './ResultsTable/CustomBody';
import CustomToolbar from './ResultsTable/CustomToolbar';
import { createData } from './ResultsTable/utils';
import mockResults from '../mocks/Results.json';

const styles = theme => ({
  root: {
    width: '100%',
    marginTop: theme.spacing.unit * 3
  },
  table: {
    minWidth: 1020
  },
  tableWrapper: {
    overflowX: 'auto'
  }
});

class CustomTable extends React.Component {
  state = {
    order: 'asc',
    selected: [],
    orderBy: mockResults.headers[0],
    headers: mockResults.headers.map(h => ({
      id: h.label,
      numeric: h.type,
      disablePadding: false,
      label: h.label
    })),
    data: mockResults.results.map(createData),
    page: 0,
    rowsPerPage: 10
  };

  isSelected = id => this.state.selected.indexOf(id) !== -1;

  handleRequestSort = (event, property) => {
    const orderBy = property;
    let order = 'desc';

    if (this.state.orderBy === property && this.state.order === 'desc') {
      order = 'asc';
    }

    this.setState({ order, orderBy });
  };

  handleSelectAllClick = event => {
    if (event.target.checked) {
      this.setState(state => ({ selected: state.data.map(n => n.id) }));
      return;
    }
    this.setState({ selected: [] });
  };

  createSortHandler = property => event => {
    this.props.onRequestSort(event, property);
  };

  handleClick = (event, id) => {
    const { selected } = this.state;
    const selectedIndex = selected.indexOf(id);
    let newSelected = [];

    if (selectedIndex === -1) {
      newSelected = newSelected.concat(selected, id);
    } else if (selectedIndex === 0) {
      newSelected = newSelected.concat(selected.slice(1));
    } else if (selectedIndex === selected.length - 1) {
      newSelected = newSelected.concat(selected.slice(0, -1));
    } else if (selectedIndex > 0) {
      newSelected = newSelected.concat(
        selected.slice(0, selectedIndex),
        selected.slice(selectedIndex + 1)
      );
    }

    this.setState({ selected: newSelected });
  };

  handleChangePage = (event, page) => {
    this.setState({ page });
  };

  handleChangeRowsPerPage = event => {
    this.setState({ rowsPerPage: event.target.value });
  };

  render() {
    const {
      data,
      headers,
      order,
      orderBy,
      selected,
      rowsPerPage,
      page
    } = this.state;

    const emptyRows =
      rowsPerPage - Math.min(rowsPerPage, data.length - page * rowsPerPage);

    return (
      <Paper>
        <CustomToolbar numSelected={selected.length} />
        <div>
          <Table aria-labelledby="tableTitle">
            <CustomHeader
              headers={headers}
              numSelected={selected.length}
              order={order}
              orderBy={orderBy}
              onSelectAllClick={this.handleSelectAllClick}
              onRequestSort={this.handleRequestSort}
              rowCount={data.length}
            />
            <CustomBody
              data={data}
              headers={headers}
              emptyRows={emptyRows}
              order={order}
              orderBy={orderBy}
              numSelected={selected.length}
              rowCount={data.length}
              page={page}
              rowsPerPage={rowsPerPage}
              selected={selected}
              handleClick={this.handleClick}
              onSelectAllClick={this.handleSelectAllClick}
              isSelected={this.isSelected}
            />
          </Table>
        </div>
        <TablePagination
          rowsPerPageOptions={[5, 10, 25]}
          component="div"
          count={data.length}
          rowsPerPage={rowsPerPage}
          page={page}
          backIconButtonProps={{
            'aria-label': 'Previous Page'
          }}
          nextIconButtonProps={{
            'aria-label': 'Next Page'
          }}
          onChangePage={this.handleChangePage}
          onChangeRowsPerPage={this.handleChangeRowsPerPage}
        />
      </Paper>
    );
  }
}

export default withStyles(styles)(CustomTable);
