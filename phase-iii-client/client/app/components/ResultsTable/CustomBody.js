import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import TableBody from '@material-ui/core/TableBody';
import Checkbox from '@material-ui/core/Checkbox';
import { stableSort, getSorting } from './utils';

class CustomBody extends React.Component {
  render() {
    const {
      data,
      order,
      orderBy,
      page,
      rowsPerPage,
      emptyRows,
      headers,
      isSelected,
      handleClick
    } = this.props;

    return (
      <TableBody>
        {stableSort(data, getSorting(order, orderBy))
          .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
          .map(n => {
            const isSelectedClosure = isSelected(n.id);
            return (
              <TableRow
                hover
                onClick={event => handleClick(event, n.id)}
                role="checkbox"
                aria-checked={isSelectedClosure}
                tabIndex={-1}
                key={n.id}
                selected={isSelectedClosure}
              >
                <TableCell padding="checkbox">
                  <Checkbox checked={isSelectedClosure} />
                </TableCell>
                {headers.map(h => (
                  <TableCell key={n.id + h.label} align="right">
                    {n[h['label']]}
                  </TableCell>
                ))}
              </TableRow>
            );
          })}
        {emptyRows > 0 && (
          <TableRow style={{ height: 49 * emptyRows }}>
            <TableCell colSpan={6} />
          </TableRow>
        )}
      </TableBody>
    );
  }
}

export default CustomBody;
