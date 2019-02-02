import React from 'react';
import { connect } from 'react-redux';
import Table from '@material-ui/core/Table';
import TablePagination from '@material-ui/core/TablePagination';
import Paper from '@material-ui/core/Paper';
import CustomHeader from './CustomHeader';
import CustomBody from './CustomBody';
import CustomToolbar from './CustomToolbar';
import { createData } from './utils';

class CustomTable extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      order: 'asc',
      orderBy: this.props.headers ? this.props.headers[0] : [],
      selected: [],
      headers: this.props.headers
        ? this.props.headers.map(h => ({
            id: h.label,
            numeric: h.type,
            disablePadding: false,
            label: h.label
          }))
        : [],
      data: this.props.data ? this.props.data.map(createData) : [],
      page: 0,
      rowsPerPage: 10
    };
  }

  render() {
    const {
      order,
      orderBy,
      headers,
      data,
      selected,
      rowsPerPage,
      page
    } = this.state;

    const { checkbox, moduleType } = this.props;
    const emptyRows =
      rowsPerPage - Math.min(rowsPerPage, data.length - page * rowsPerPage);

    return (
      <Paper className="customTable__container">
        <CustomToolbar numSelected={selected.length} />
        <div className="customTable__wrapper">
          <Table className="customTable__table" aria-labelledby="tableTitle">
            <CustomHeader
              headers={headers}
              checkbox={checkbox}
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
              checkbox={checkbox}
              moduleType={moduleType}
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
          rowsPerPageOptions={[5, 10]}
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
}

const mapStateToProps = state => {
  return { selectedItem: state.tableReducer.selected };
};

export default connect(mapStateToProps)(CustomTable);
