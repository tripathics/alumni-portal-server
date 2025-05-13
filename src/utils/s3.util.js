import { PutObjectCommand, DeleteObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { s3Client, bucketName } from '../config/s3.config.js';
import ApiError from './ApiError.util.js';
import logger from '../config/logger.config.js';

export const uploadCategories = {
  avatar: {
    allowedTypes: ['image/jpeg'],
    maxSize: 2097152, // 2MB
  },
  sign: { allowedTypes: ['image/jpeg'], maxSize: Infinity },
  post: {
    allowedTypes: ['image/webp', 'image/jpeg', 'image/jpg', 'image/png'],
    maxSize: Infinity,
  },
  hero: {
    allowedTypes: ['image/webp', 'image/jpeg', 'image/jpg', 'image/png'],
    maxSize: 3145728, // 3MB
  },
};

/**
 * Generates a signed URL for uploading a file to S3.
 *
 * @param {Object} params - The parameters for generating the signed URL.
 * @param {string} params.filename - The name of the file to be uploaded.
 * @param {string} params.fileType - The MIME type of the file to be uploaded.
 * @param {string} [params.type='avatar'] - The type of the file, (used in S3 key prefix).
 * @returns {Promise<{url: string, key: string}>} An object with the signed URL and the S3 key.
 * @throws {ApiError} If the filename or fileType is not provided.
 */
export const getSignedUploadUrl = async ({
  filename,
  fileType,
  type = 'avatar',
}) => {
  if (!filename || !fileType) {
    throw new ApiError(400, 'S3', 'Filename and fileType are required.');
  }

  const key = `${type}/${filename}`;
  const contentType = fileType;

  const url = await getSignedUrl(
    s3Client,
    new PutObjectCommand({
      Bucket: bucketName,
      Key: key,
      ContentType: contentType,
    }),
  );

  return { url, key };
};

export const deleteObject = async (key) => {
  try {
    if (!key) throw new Error('Key not provided');
    const command = new DeleteObjectCommand({
      Bucket: bucketName,
      Key: key,
    });
    await s3Client.send(command);
    logger.info(`Object ${key} deleted`);
  } catch (e) {
    throw new ApiError(500, 'Media', e.message);
  }
};

export const extractKeyFromUrl = (filename) => {
  const [key] = filename.split('?');
  return key;
};

export const createTimestampedFileUrl = (filename) =>
  filename ? `${filename}?updated_at=${new Date().getTime()}` : null;

export const getS3Url = (filename, type) =>
  `https://${process.env.AWS_S3_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com/${type}/${filename}`;
