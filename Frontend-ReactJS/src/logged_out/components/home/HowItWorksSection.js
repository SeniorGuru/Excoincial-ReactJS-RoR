import React, { Fragment } from "react";
import PropTypes from "prop-types";
import {
  withStyles,
  withWidth,
  Typography,
  Grid
} from "@material-ui/core";
import HowItWorksSectionImage from "../../../assets/images/How-it-works.png";
import stepImage from "../../../assets/images/numbers-bg.png";

const styles = theme => ({
  HowItWorksSection: {
    background: `url(${HowItWorksSectionImage}) center no-repeat`,
    backgroundSize: `cover`,
    height: '100%',
    padding: `100px 10% 30px 10%`,
  },
  howItWorks: {
    color: theme.palette.background.default,
    fontWeight: 900,
    textAlign: `center`,
    marginBottom: 50
  },
  howItWorksStep: {
    backgroundImage: `url(${stepImage})`,
    backgroundRepeat: `no-repeat`,
    backgroundPosition: `center top`,
    textAlign: `center`,
    justifyContent: `center`,
    paddingTop: 69
  },
  stepImage:{
    width: 222,
    height:222
  },
  stepNumber:{
    backgroundColor: theme.palette.primary.main,
    borderRadius:90,
    width: 90,
    height: 90,
    fontSize: 66,
    fontWeight: 900,
    color: theme.palette.background.default,
    margin: `0px auto`,
  },
  verticalBar: {
    width: 1,
    height: 70,
    border: `1px solid ${theme.palette.warning.dark}`,
    margin: `20px auto`
  }
});

function HowItWorksSection(props) {
  const { classes, theme } = props;
  return (
    <Fragment>
      <div className={classes.HowItWorksSection}>
        <Typography variant="h2" className={classes.howItWorks}>
          HOW IT WORKS
        </Typography>
        <Grid container>
          <Grid item lg={4} md={4} sm={12} xs={12}>
            <div key={`how-it-works-step-1`} className={classes.howItWorksStep}>
              <Typography className={classes.stepNumber}>
                1
              </Typography>
              <div key={`vertical-bar-1`} className={classes.verticalBar}></div>
              <Typography variant="h4" style={{color: theme.palette.background.default}}>
                SIGNUP
              </Typography>
              <Typography style={{color: theme.palette.background.default, padding: 20}}>
                Sign up and get registered with the Exchange. Once you have registered, wait for email confirmation and follow the KYC process. As soon as your account iis confirmed log in and start seamless trading with over 80+ listed fiat currency and cryptocurrency pairs to choose from.
              </Typography>
            </div>
          </Grid>
          <Grid item lg={4} md={4} sm={12} xs={12}>
            <div key={`how-it-works-step-2`} className={classes.howItWorksStep}>
              <Typography className={classes.stepNumber}>
                2
              </Typography>
              <div key={`vertical-bar-2`} className={classes.verticalBar}></div>
              <Typography variant="h4" style={{color: theme.palette.background.default}}>
                SUBMIT KYC
              </Typography>
              <Typography style={{color: theme.palette.background.default, padding: 20}}>
              When you login, simply go to profile page and complete your KYC verification process and allow our Customer Documents Management and Compliance Team to verify and approve your documents using our AML supportive system.
              </Typography>
            </div>
          </Grid>
          <Grid item lg={4} md={4} sm={12} xs={12}>
            <div key={`how-it-works-step-3`} className={classes.howItWorksStep}>
              <Typography className={classes.stepNumber}>
                3
              </Typography>
              <div key={`vertical-bar-3`} className={classes.verticalBar}></div>
              <Typography variant="h4" style={{color: theme.palette.background.default}}>
                START TRADING
              </Typography>
              <Typography style={{color: theme.palette.background.default, padding: 20}}>
              EXCOINCIAL is a user-driven exchange with a friendly and welcoming user-interface. Registered users get access to all our advanced features at no extra cost. Trading on EXCOINCIAL is as easy as getting started. In three simple steps you can start trading today!
              </Typography>
            </div>
          </Grid>
        </Grid>
      </div>
    </Fragment>
  );
}

HowItWorksSection.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  theme: PropTypes.object
};

export default withWidth()(
  withStyles(styles, { withTheme: true })(HowItWorksSection)
);
