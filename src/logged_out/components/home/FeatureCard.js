import React, { Fragment } from "react";
import PropTypes from "prop-types";
import { Typography, withStyles } from "@material-ui/core";

const styles = theme => ({
  iconWrapper: {
    borderRadius: theme.shape.borderRadius,
    textAlign: "center",
    display: "inline-flex",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: theme.spacing(3),
    padding: theme.spacing(1) * 1.5
  },
  overflowContent: {
    letterSpacing: `-0.03em`,
    lineHeight: `20px`,
    textAlign:`center`
  },
  Content: {
    marginLeft:`-8px`,
    textAlign:`center`
  }
});

function FeatureCard(props) {
  const { classes, Icon, content, hasOverflow, theme } = props;
  return (
    <Fragment>
      <div
        className={classes.iconWrapper}
        style={{
          boxShadow: theme.shadows[6],
          width: `100%`,
          height: `100%`,
          textOverflow: `ellipsis`,
          justifyContent: `left`
        }}
      >
        <img
          src={Icon}
          style={{marginRight:20}}
          alt={"Feature-Card"}
        />
        <Typography variant="body1" className={hasOverflow?classes.overflowContent:classes.Content}>
        {content}
      </Typography>
      </div>      
    </Fragment>
  );
}

FeatureCard.propTypes = {
  classes: PropTypes.object.isRequired,
  Icon: PropTypes.string.isRequired,
  content: PropTypes.string.isRequired,
  hasOverflow: PropTypes.bool.isRequired,
  theme: PropTypes.object
};

export default withStyles(styles, { withTheme: true })(FeatureCard);
