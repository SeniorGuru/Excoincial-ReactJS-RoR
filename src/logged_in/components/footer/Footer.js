import React from "react";
import PropTypes from "prop-types";
import {
  withStyles,
  withWidth,
  Link,
  Typography,
  Grid,
} from "@material-ui/core";

const styles = theme => ({
  footer: {
    position: `fixed`,
    width: `100%`,
    zIndex: 102,
    bottom: 0,
  },
  footerInner: {
    backgroundColor: theme.palette.common.darkBlack,
    paddingTop: theme.spacing(2),
    paddingLeft: theme.spacing(5),
    paddingRight: theme.spacing(5),
    paddingBottom: theme.spacing(2),
    [theme.breakpoints.up("sm")]: {
      paddingTop: theme.spacing(2),
      paddingLeft: theme.spacing(5),
      paddingRight: theme.spacing(5),
      paddingBottom: theme.spacing(2)
    },
    [theme.breakpoints.up("md")]: {
      paddingTop: theme.spacing(2),
      paddingLeft: theme.spacing(5),
      paddingRight: theme.spacing(5),
      paddingBottom: theme.spacing(2)
    }
  },
  footerInner1:{
    backgroundColor: theme.palette.background.default,
    paddingTop: theme.spacing(2),
    paddingLeft: theme.spacing(5),
    paddingRight: theme.spacing(5),
    paddingBottom: theme.spacing(2),
    [theme.breakpoints.up("sm")]: {
      paddingTop: theme.spacing(2),
      paddingLeft: theme.spacing(5),
      paddingRight: theme.spacing(5),
      paddingBottom: theme.spacing(2)
    },
    [theme.breakpoints.up("md")]: {
      paddingTop: theme.spacing(2),
      paddingLeft: theme.spacing(5),
      paddingRight: theme.spacing(5),
      paddingBottom: theme.spacing(2)
    },
    textAlign: `center`
  },
  footerMenu: {
    color:theme.palette.background.default,
    fontSize: 12,
    [theme.breakpoints.down("md")]:{
      fontSize:10,
    },
    [theme.breakpoints.down("md")]:{
      fontSize:10,
    },
  }
});

function Footer(props) {
  const { classes } = props;
  return (
    <footer className={classes.footer}>
      <div className={classes.footerInner}>
        <Grid container>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                SUPPORT
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                FAQ
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                BLOG
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={6}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                TERMS AND CONDITIONS
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                PRIVACY POLICY
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                SYSTEM STATUS
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                MARKETS
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                FEES
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                API
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                COINS INFO
              </Typography>
            </Link>
          </Grid>
          <Grid item lg={1} md={1} sm={2} xs={4}>
            <Link
              to={`/`}
            >
              <Typography variant="h6" className={classes.footerMenu}>
                WHITEPAPER
              </Typography>
            </Link>
          </Grid>
        </Grid>
      </div>
      <div className={classes.footerInner1}>
        © 2018 - 2019 EXCOINCIAL. All rights reserved
      </div>
    </footer>
  );
}

Footer.propTypes = {
  theme: PropTypes.object.isRequired,
  classes: PropTypes.object.isRequired,
  width: PropTypes.string.isRequired
};

export default withWidth()(withStyles(styles, { withTheme: true })(Footer));
