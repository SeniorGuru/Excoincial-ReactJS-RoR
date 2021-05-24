import React, { Fragment } from "react";
import PropTypes from "prop-types";
import AliceCarousel from 'react-alice-carousel';
import "react-alice-carousel/lib/alice-carousel.css";
import image1 from "../../../assets/images/first-add.png";
import image2 from "../../../assets/images/sec-add.png";
import image3 from "../../../assets/images/thired-add.png";
import {
  withStyles,
  withWidth,
} from "@material-ui/core";
import slideSectionImage from "../../../assets/images/circle-bg.png";

const styles = theme => ({
  slideSection: {
    background: `url(${slideSectionImage}) center no-repeat`,
    // backgroundSize: `100% 100%`,
    height: '100%',
    paddingTop: theme.spacing(5),
    paddingBottom:`4vh`,
    [theme.breakpoints.down("md")]:{
      paddingBottom:`10vh`,
    }
  },
  sliderHide:{
    paddingLeft:10,
    paddingRight:10,
    [theme.breakpoints.down("sm")]:{
      display:'none',
    }
  },
  slider:{
    display: `flex`,
    justifyContent: `center`,
  },
  sliderDiv:{
    paddingLeft:10,
    paddingRight:10,
  },
  sliderImage:{
    borderRadius: 25,
  }
});


function slideSection(props) {
  const { classes,  } = props;
  return (
    <Fragment>
      <div className={classes.slideSection}>
        <AliceCarousel autoPlay autoPlayInterval={2000}>
          <div key={`slider1`} className={classes.slider}>
            <div key={`slider1-1`} className={classes.sliderDiv}>
              <img src={image1} className={classes.sliderImage} alt=""/>
            </div>
            <div key={`slider1-2`} className={classes.sliderHide}>
              <img src={image2} className={classes.sliderImage} alt=""/>
            </div>
            <div key={`slider1-3`} className={classes.sliderHide}>
              <img src={image3} className={classes.sliderImage} alt=""/>
            </div>
          </div>
          <div key={`slider2`} className={classes.slider}>
            <div key={`slider2-2`} className={classes.sliderDiv}>
              <img src={image2} className={classes.sliderImage} alt=""/>
            </div>
            <div key={`slider2-3`} className={classes.sliderHide}>
              <img src={image3} className={classes.sliderImage} alt=""/>
            </div>
            <div key={`slider2-1`} className={classes.sliderHide}>
              <img src={image1} className={classes.sliderImage} alt=""/>
            </div>
          </div>
          <div key={`slider3`} className={classes.slider}>
            <div key={`slider3-3`} className={classes.sliderDiv}>
              <img src={image3} className={classes.sliderImage} alt=""/>
            </div>
            <div key={`slider3-1`} className={classes.sliderHide}>
              <img src={image1} className={classes.sliderImage} alt=""/>
            </div>
            <div key={`slider3-2`} className={classes.sliderHide}>
              <img src={image2} className={classes.sliderImage} alt=""/>
            </div>
          </div>
        </AliceCarousel>
      </div>
    </Fragment>
  );
}

slideSection.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  theme: PropTypes.object
};

export default withWidth()(
  withStyles(styles, { withTheme: true })(slideSection)
);
