// @flow
import React, { Component } from 'react';
import Paper from '@material-ui/core/Paper';
import FormControl from '@material-ui/core/FormControl';
import MenuItem from '@material-ui/core/MenuItem';
import Select from '@material-ui/core/Select';
import InputLabel from '@material-ui/core/InputLabel';
import { Bar } from 'react-chartjs-2';
import palette from 'google-palette';

class ActivityPatterns extends Component {
  constructor(props) {
    super(props);

    const uniqueDays = this.uniqueDays(props.data);
    const uniqueMonths = this.uniqueMonths(props.data);

    this.state = {
      select: 'Day',
      uniqueDays,
      uniqueMonths,
      selectedDay: uniqueDays[0],
      selectedMonth: uniqueMonths[0],
      dataPlot: {},
      options: {}
    };

    this.computeOptions = this.computeOptions.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleChangeDay = this.handleChangeDay.bind(this);
    this.handleChangeMonth = this.handleChangeMonth.bind(this);
  }

  componentDidMount() {
    this.computeOptions();
  }

  handleChange(event) {
    this.setState({ select: event.target.value }, () => {
      this.computeOptions();
    });
  }

  handleChangeDay(event) {
    this.setState({ selectedDay: event.target.value }, () => {
      this.computeOptions();
    });
  }

  handleChangeMonth(event) {
    this.setState({ selectedMonth: event.target.value }, () => {
      this.computeOptions();
    });
  }

  render() {
    const {
      dataPlot,
      options,
      select,
      uniqueDays,
      uniqueMonths,
      selectedDay,
      selectedMonth
    } = this.state;
    return (
      <div className="row col-xs-24 center-xs">
        <div className="row col-xs-24 activityPatterns__select">
          <div className="col-xs-off-1 col-xs-7">
            <FormControl>
              <InputLabel className="col-xs-24" htmlFor="age-simple">
                Activity patter per:{' '}
              </InputLabel>
              <Select
                style={{ width: '250px' }}
                value={select}
                onChange={this.handleChange}
              >
                <MenuItem className="col-xs-21" value={'Day'}>
                  Day
                </MenuItem>
                <MenuItem className="col-xs-21" value={'Month'}>
                  Month
                </MenuItem>
              </Select>
            </FormControl>
          </div>
          <div className="col-xs-off-1 col-xs-7">
            <FormControl>
              <InputLabel className="col-xs-24" htmlFor="age-simple">
                Month:{' '}
              </InputLabel>
              <Select
                style={{ width: '250px' }}
                value={selectedMonth}
                onChange={this.handleChangeMonth}
              >
                {uniqueMonths.map(month => (
                  <MenuItem className="col-xs-21" value={month}>
                    {month}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
          </div>
          {select === 'Day' && (
            <div className="col-xs-off-1 col-xs-7">
              <FormControl>
                <InputLabel className="col-xs-24" htmlFor="age-simple">
                  Day:{' '}
                </InputLabel>
                <Select
                  style={{ width: '250px' }}
                  value={selectedDay}
                  onChange={this.handleChangeDay}
                >
                  {uniqueDays.map(day => (
                    <MenuItem className="col-xs-21" value={day}>
                      {day}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </div>
          )}
        </div>
        <div className="col-xs-21 plots__highchart">
          <Paper elevation={1}>
            <Bar
              className="plots__scatter"
              data={dataPlot}
              options={options}
              height={150}
            />
          </Paper>
        </div>
      </div>
    );
  }

  computeOptions() {
    const { select } = this.state;

    const dataPlot =
      select === 'Day' ? this.computePerDay() : this.computePerMonth();
    this.setState({
      dataPlot,
      options: {
        maintainAspectRatio: false,
        title: {
          display: true,
          text: 'Calls frequency'
        },
        layout: {
          padding: {
            left: 50,
            right: 70,
            top: 0,
            bottom: 50
          }
        },
        scales: {
          yAxes: [
            {
              scaleLabel: {
                display: true,
                labelString: 'Frequency'
              }
            }
          ],
          xAxes: [
            {
              scaleLabel: {
                display: true,
                labelString: select === 'Day' ? 'Hours' : 'Days'
              }
            }
          ]
        },
        tooltips: {
          mode: 'single',
          callbacks: {
            title: () => '',
            label: function(tooltipItem, data) {
              var multistringText =
                data.datasets[tooltipItem.datasetIndex].label || '';
              return multistringText;
            },
            footer: function(tooltipItem) {
              return [
                `${select}: ${tooltipItem[0].xLabel}`,
                `Frequency: ${tooltipItem[0].yLabel}`
              ];
            }
          }
        }
      }
    });
  }

  uniqueMonths(data) {
    const months = data.map(datum =>
      Number(datum['Filename'].split('_')[1].substring(4, 6))
    );
    return months
      .filter((d, i) => months.indexOf(d) === i)
      .sort((a, b) => (a > b ? 1 : -1));
  }

  uniqueDays(data) {
    const days = data.map(datum =>
      Number(datum['Filename'].split('_')[1].substring(6, 8))
    );
    return days
      .filter((d, i) => days.indexOf(d) === i)
      .sort((a, b) => (a > b ? 1 : -1));
  }

  computePerDay() {
    const { data, clusters } = this.props;
    const { selectedDay, selectedMonth } = this.state;
    const colors = palette('mpn65', clusters.length);
    const hours = Array.from({ length: 24 }, (e, i) => i + 1);

    const series = clusters.map((c, i) => ({
      label: `Cluster ${c['Cluster']}`,
      data: data
        .filter(point => Number(point['Cluster']) === Number(c['Cluster']))
        .map(value => value['Filename'])
        .filter(
          value => Number(value.split('_')[1].substring(4, 6)) === selectedMonth
        )
        .filter(
          value => Number(value.split('_')[1].substring(6, 8)) === selectedDay
        )
        .reduce((a, value) => {
          const hour = Number(value.split('_')[2].substring(2, 4)) - 1;
          a[hour] = a[hour] + 1;
          return a;
        }, Array.from({ length: 24 }, () => 0)),
      pointHoverBorderWidth: 5,
      pointRadius: 4,
      backgroundColor: '#' + colors[i]
    }));

    return {
      labels: hours,
      datasets: series
    };
  }

  computePerMonth() {
    const { data, clusters } = this.props;
    const { selectedDay, selectedMonth } = this.state;
    const colors = palette('mpn65', clusters.length);
    const days = Array.from({ length: 31 }, (e, i) => i + 1);
    const frequency = Array.from({ length: 24 }, () => 0);

    const series = clusters.map((c, i) => ({
      label: `Cluster ${c['Cluster']}`,
      data: data
        .filter(point => Number(point['Cluster']) === Number(c['Cluster']))
        .map(value => value['Filename'])
        .filter(
          value => Number(value.split('_')[1].substring(4, 6)) === selectedMonth
        )
        .reduce((a, value) => {
          const day = Number(value.split('_')[1].substring(6, 8)) - 1;
          a[day] = a[day] + 1;
          return a;
        }, Array.from({ length: 24 }, () => 0)),
      pointHoverBorderWidth: 5,
      pointRadius: 4,
      backgroundColor: '#' + colors[i]
    }));

    return {
      labels: days,
      datasets: series
    };
  }
}

export default ActivityPatterns;
