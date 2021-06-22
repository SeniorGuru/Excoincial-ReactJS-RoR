import React, {Fragment } from "react";
import PropTypes from "prop-types";
import {
  withStyles,
  withWidth,
  Typography
} from "@material-ui/core";
import landingImage from "../../../assets/images/file-icon.png";

const styles = theme => ({
    ContentBlank: {
      display: `flex`,
      justifyContent: `center`,
      background: `url("${landingImage}") center center no-repeat`,
      paddingTop: 320,
      marginLeft:200,
      paddingBottom: 200,
    },   
});

function Content(props) {
    const { classes } = props;
  
    return (
        <Fragment>            
            <div key={"rewardcenter-blank"} className={classes.ContentBlank} >
                No Vouchers
            </div>
        </Fragment>
    );
}


Content.propTypes = {
    classes: PropTypes.object,
    width: PropTypes.string,
    theme: PropTypes.object
  };
  
  export default withWidth()(
    withStyles(styles, { withTheme: true })(Content)
  );
  