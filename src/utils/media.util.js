import fs from 'fs';
import path from 'path';
import ApiError from './ApiError.util.js';
import { AVATAR_DIR, SIGN_DIR } from '../config/storage.config.js';

const deleteFile = async (filename, type) => {
  const dirname = type === 'avatar' ? AVATAR_DIR : SIGN_DIR;

  try {
    await fs.promises.unlink(path.join(dirname, filename));
  } catch (error) {
    if (error.code !== 'ENOENT') {
      throw new ApiError(500, 'File', 'Error deleting file');
    }
  }
};

const createTimestampedFileUrl = (filename) =>
  filename ? `${filename}?updated_at=${new Date().getTime()}}` : null;

export const createTimestampedAvatarUrl = (filename) =>
  createTimestampedFileUrl(filename);

export const createTimestampedSignUrl = (filename) =>
  createTimestampedFileUrl(filename);

export const getS3Url = (filename, type) =>
  `https://${process.env.AWS_S3_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com/${type}/${filename}`;

export default deleteFile;
