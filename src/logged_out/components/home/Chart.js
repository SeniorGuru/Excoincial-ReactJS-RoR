import React from "react";
import PropTypes from "prop-types";
import { Grid, withTheme } from "@material-ui/core";

function Chart(props) {
  const { theme, LiveChart, data } = props;
  if (LiveChart) {
    return (
      data.profit.length >= 2 &&
      data.views.length >= 2 && (
        <LiveChart
          data={data.profit}
          color={theme.palette.warning.dark}
          height="35px"
        />
      )
    );
  }
  return <div>Null</div>
}

Chart.propTypes = {
  theme: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
  LiveChart: PropTypes.elementType
};

export default withTheme(Chart);
