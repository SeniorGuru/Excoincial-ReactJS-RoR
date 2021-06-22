import React, { useState, useCallback } from "react";
import PropTypes from "prop-types";
import {
  AreaChart,
  Area,
  XAxis,
  Tooltip,
  ResponsiveContainer,
  YAxis,
} from "recharts";
import format from "date-fns/format";
import {
  Card,
  CardContent,
  Typography,
  IconButton,
  Menu,
  MenuItem,
  withStyles,
  Box,
} from "@material-ui/core";
import MoreVertIcon from "@material-ui/icons/MoreVert";

const styles = (theme) => ({
  cardContentInner: {
    marginTop: 0,
    width:`70%`,
    float:`right`,
  },
});

function labelFormatter(label) {
  return format(new Date(label * 1000), "MMMM d, p yyyy");
}

function calculateMin(data, yKey, factor) {
  let max = Number.POSITIVE_INFINITY;
  data.forEach((element) => {
    if (max > element[yKey]) {
      max = element[yKey];
    }
  });
  return Math.round(max - max * factor);
}


function LiveChart(props) {
  const { color, data, title, classes, theme, height } = props;
  const [selectedOption, setSelectedOption] = useState("1 Month");

  const formatter = useCallback(
    (value) => {
      return [value, title];
    },
    [title]
  );


  const processData = useCallback(() => {
    let seconds;
    switch (selectedOption) {
      case "1 Week":
        seconds = 60 * 60 * 24 * 7;
        break;
      case "1 Month":
        seconds = 60 * 60 * 24 * 31;
        break;
      case "6 Months":
        seconds = 60 * 60 * 24 * 31 * 6;
        break;
      default:
        throw new Error("No branch selected in switch-statement");
    }
    const minSeconds = new Date() / 1000 - seconds;
    const arr = [];
    for (let i = 0; i < data.length; i += 1) {
      if (minSeconds < data[i].timestamp) {
        arr.unshift(data[i]);
      }
    }
    return arr;
  }, [data, selectedOption]);


  return (
    <Box className={classes.cardContentInner} height={height}>
      <ResponsiveContainer width="100%" height="100%">
        <AreaChart data={processData()} type="number">
          <XAxis
            dataKey="timestamp"
            type="number"
            domain={["dataMin", "dataMax"]}
            hide
          />
          <YAxis
            domain={[calculateMin(data, "value", 0.05), "dataMax"]}
            hide
          />
          <Area
            type="monotone"
            dataKey="value"
            stroke={color}
            fill={color}
          />
          {/* <Tooltip
            labelFormatter={labelFormatter}
            formatter={formatter}
            cursor={false}
            contentStyle={{
              border: "none",
              padding: 0,
              borderRadius: theme.shape.borderRadius,
              boxShadow: theme.shadows[1],
            }}
            labelStyle={theme.typography.body1}
            itemStyle={{
              fontSize: theme.typography.body1.fontSize,
              letterSpacing: theme.typography.body1.letterSpacing,
              fontFamily: theme.typography.body1.fontFamily,
              lineHeight: theme.typography.body1.lineHeight,
              fontWeight: theme.typography.body1.fontWeight,
            }}
          /> */}
        </AreaChart>
      </ResponsiveContainer>
    </Box>
  );
}

LiveChart.propTypes = {
  color: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired,
  title: PropTypes.string.isRequired,
  classes: PropTypes.object.isRequired,
  theme: PropTypes.object.isRequired,
  height: PropTypes.string.isRequired,
};

export default withStyles(styles, { withTheme: true })(LiveChart);
