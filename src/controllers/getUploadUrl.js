import { uploadCategories, getSignedUploadUrl } from '../config/s3.config.js';
import ApiError from '../utils/ApiError.util.js';

export const getUploadUrl = async (req, res, next) => {
  try {
    const { type } = req.params;
    const { filename, filetype, filesize } = req.query;

    if (!filename || !filetype || !filesize) {
      throw new ApiError(
        400,
        'Media',
        'filename, filetype and filesize are required',
      );
    }

    if (!uploadCategories[type]?.allowedTypes.includes(filetype)) {
      const typeAllowed = uploadCategories[type].allowedTypes;
      throw new ApiError(
        400,
        'Media',
        `Only ${typeAllowed.join(', ')} files are allowed for ${type}`,
      );
    }
    if (filesize > uploadCategories[type]?.maxSize) {
      throw new ApiError(
        400,
        'Media',
        `File size should be less than ${uploadCategories.avatar.maxSize / 1000000}MB`,
      );
    }

    if (type === 'hero' && !req.tokenPayload.role.includes('admin')) {
      throw new ApiError(403, 'Media', 'Only admin can upload hero images');
    }

    const extension = filetype.split('/')[1];
    let name = filename;
    if (type === 'avatar') {
      if (filesize > 2097152) {
        throw new ApiError(400, 'Media', 'File size should be less than 2MB');
      }
      name = `${req.tokenPayload.id}.${extension}`;
    }

    if (!filename || !filetype) {
      throw new ApiError(400, 'Media', 'filename and filetype are required');
    }

    const { key, url } = await getSignedUploadUrl({
      filename: name,
      fileType: filetype,
      type,
    });

    res.send({ key, url });
  } catch (err) {
    next(err);
  }
};
