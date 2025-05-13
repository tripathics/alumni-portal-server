import HeroSection from '../models/heroSection.model.js';

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
