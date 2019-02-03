// @flow
import React, { Component } from 'react';
import { connect } from 'react-redux';
import Paper from '@material-ui/core/Paper';
import FormControl from '@material-ui/core/FormControl';
import VariableSelect from './VariableSelect';
import { Scatter } from 'react-chartjs-2';
import palette from 'google-palette';

class Plots extends Component {
  constructor(props) {
    super(props);
    this.state = {
      dataPlot: {},
      options: {}
    };
  }

  componentWillReceiveProps(nextProps) {
    const { variable_x, variable_y } = nextProps.radiosState;
    const { data, clusters } = nextProps;
    this.computeOptions(variable_x, variable_y, data, clusters);
  }

  render() {
    const { dataPlot, options } = this.state;
    const { headers } = this.props;
    return (
      <FormControl className="col-xs-24">
        <div className="row col-xs-24 center-xs">
          <Paper className="col-xs-10" elevation={1}>
            <VariableSelect
              title="Select X:"
              model="variable_x"
              options={headers.slice(4)}
            />
          </Paper>
          <Paper className="col-xs-off-1 col-xs-10" elevation={1}>
            <VariableSelect
              title="Select Y:"
              model="variable_y"
              options={headers.slice(4)}
            />
          </Paper>
          <div className="col-xs-21 plots__highchart">
            <Paper elevation={1}>
              <Scatter
                className="plots__scatter"
                data={dataPlot}
                options={options}
                height={100}
              />
            </Paper>
          </div>
        </div>
      </FormControl>
    );
  }

  computeOptions(xLabel, yLabel, data, clusters) {
    const colors = palette('mpn65', clusters.length);
    const series = clusters.map((c, i) => ({
      label: `Cluster ${c['Cluster']}`,
      data: data
        .filter(point => Number(point['Cluster']) === Number(c['Cluster']))
        .map(point => ({ x: point[xLabel], y: point[yLabel] })),
      pointHoverBorderWidth: 5,
      pointRadius: 4,
      backgroundColor: '#' + colors[i]
    }));
    this.setState({
      dataPlot: {
        labels: ['Scatter'],
        datasets: series
      },
      options: {
        maintainAspectRatio: false,
        title: {
          display: true,
          text: 'Calls distribution'
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
                labelString: yLabel
              }
            }
          ],
          xAxes: [
            {
              scaleLabel: {
                display: true,
                labelString: xLabel
              }
            }
          ]
        },
        tooltips: {
          mode: 'single',
          callbacks: {
            label: function(tooltipItem, data) {
              var multistringText =
                data.datasets[tooltipItem.datasetIndex].label || '';
              return multistringText;
            },
            footer: function(tooltipItems) {
              return [
                `${xLabel} ${tooltipItems[0].xLabel}`,
                `${yLabel} ${tooltipItems[0].yLabel}`
              ];
            }
          }
        }
      }
    });
  }
}

const mapStateToProps = state => {
  return { radiosState: state.plotReducer.radiosState };
};

export default connect(mapStateToProps)(Plots);
