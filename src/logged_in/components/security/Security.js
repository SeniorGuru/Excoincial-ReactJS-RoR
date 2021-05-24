import React, { Fragment, useEffect } from "react";
import PropTypes from "prop-types";
import { Typography, Box } from "@material-ui/core";
import Content from './Content';


function Security(props) {
    const { selectSecurity } = props;
    useEffect(() => {
        selectSecurity();
      }, [selectSecurity]);
    return (
        <Fragment>
            <Content />
        </Fragment>        
    );
}

Security.propTypes = {
  selectSecurity: PropTypes.func.isRequired
  };

export default Security;