import React, { Fragment, useEffect } from "react";
import PropTypes from "prop-types";
import { Typography, Box } from "@material-ui/core";
import Content from './Content';


function Preferences(props) {
    const { selectPreferences } = props;
    useEffect(() => {
      selectPreferences();
      }, [selectPreferences]);
    return (
        <Fragment>
            <Content />
        </Fragment>        
    );
}

Preferences.propTypes = {
  selectPreferences: PropTypes.func.isRequired
  };

export default Preferences;