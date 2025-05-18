import HeroSection from '../models/heroSection.model.js';
import WebMessages from '../models/webMessages.model.js';

export const getHeroContent = async (req, res, next) => {
  try {
    const heroContent = await new HeroSection().find();

    if (!heroContent) {
      return res.status(404).json({ message: 'Hero content not found' });
    }

    return res.status(200).json(heroContent);
  } catch (error) {
    next(error);
  }
};

export const getMessage = async (req, res, next) => {
  try {
    const messageFrom = req.query.message_from;
    let messages = null;
    if (messageFrom === 'president') {
      messages = await new WebMessages().findPresidentsMessage();
    } else if (messageFrom === 'director') {
      messages = await new WebMessages().findDirectorsMessage();
    } else {
      messages = await new WebMessages().find();
    }
    res.json({ success: true, messages });
  } catch (error) {
    next(error);
  }
};
