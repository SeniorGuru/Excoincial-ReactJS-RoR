import React, { Fragment } from "react";
import PropTypes from "prop-types";
import {
  withStyles,
  withWidth,
  Typography,
  Grid
} from "@material-ui/core";
import PartnersRightImage from "../../../assets/images/partner-right.png";
import PartnersLeftImage from "../../../assets/images/partners-left.png";
import PartnerImage1 from "../../../assets/images/client/1.png";
import PartnerImage2 from "../../../assets/images/client/2.png";
import PartnerImage3 from "../../../assets/images/client/3.png";
import PartnerImage4 from "../../../assets/images/client/4.png";
import PartnerImage5 from "../../../assets/images/client/5.png";
import PartnerImage6 from "../../../assets/images/client/6.png";
import PartnerImage7 from "../../../assets/images/client/7.png";
import PartnerImage8 from "../../../assets/images/client/8.png";
import PartnerImage9 from "../../../assets/images/client/9.png";
import PartnerImage10 from "../../../assets/images/client/10.png";
import PartnerImage11 from "../../../assets/images/client/11.png";
import PartnerImage12 from "../../../assets/images/client/12.png";
import PartnerImage13 from "../../../assets/images/client/13.png";

const styles = theme => ({
  PartnersSection: {
    backgroundImage: `url(${PartnersRightImage}), url(${PartnersLeftImage})`,
    backgroundPosition: `right center, left center`,
    backgroundRepeat: `no-repeat, no-repeat`,
    height: '100%',
    paddingTop: `100px`,
    paddingLeft: `10%`,
    paddingRight: `10%`,
    paddingBottom: theme.spacing(10),
  },
  partnersText: {
    color: theme.palette.common.black,
    textAlign:`center`,
    fontWeight: 900,
    paddingBottom: theme.spacing(10)
  },
  partnerImage: {
    margin: `auto`,
    display: `block`,
    maxHeight: `100%`,
    maxWidth: `100%`,    
    [theme.breakpoints.down("md")]:{
      width:`100%`
    },  
    [theme.breakpoints.down("sm")]:{
      width:`100%`
    },
  },
  partnerDiv: {
    marginBottom: 30
  }
});

function PartnersSection(props) {
  const { classes } = props;
  return (
    <Fragment>
      <div className={classes.PartnersSection}>
        <Typography variant="h2" className={classes.partnersText}>
          PARTNERS
        </Typography>
        <Grid container>
          <Grid item lg={3} md={3} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage1}
                className={classes.partnerImage}
              />
            </div>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage2}
              />
            </div>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage3}
              />
            </div>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage4}
              />
            </div>
          </Grid>
          <Grid item lg={3} md={3} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage5}
              />
            </div>
          </Grid>
          <Grid item lg={3} md={3} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage6}
              />
            </div>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage7}
              />
            </div>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage8}
              />
            </div>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage9}
              />
            </div>
          </Grid>
          <Grid item lg={3} md={3} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage10}
              />
            </div>
          </Grid>
          <Grid item lg={3} md={3} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}></Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage11}
              />
            </div>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage12}
              />
            </div>
          </Grid>
          <Grid item lg={2} md={2} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}>
            <div className={classes.partnerDiv}>
              <img
                alt=""
                src={PartnerImage13}
              />
            </div>
          </Grid>
          <Grid item lg={3} md={3} sm={4} xs={12} style={{textAlign:`center`, margin:`auto`}}></Grid>
        </Grid>
      </div>
    </Fragment>
  );
}

PartnersSection.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  theme: PropTypes.object
};

export default withWidth()(
  withStyles(styles, { withTheme: true })(PartnersSection)
);
