import {
  S3, HeadBucketCommand, CreateBucketCommand, PutObjectCommand,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import ApiError from '../utils/ApiError.util.js';

const {
  AWS_S3_BUCKET,
  AWS_ACCESS_KEY_ID,
  AWS_SECRET_ACCESS_KEY,
  AWS_REGION,
} = process.env;

export const s3 = new S3({
  region: AWS_REGION,
  credentials: {
    accessKeyId: AWS_ACCESS_KEY_ID,
    secretAccessKey: AWS_SECRET_ACCESS_KEY,
  },
});

export const createBucketIfNotExists = async (bucketName) => {
  try {
    await s3.send(new HeadBucketCommand({ Bucket: bucketName }));
    console.log(`Bucket "${bucketName}" already exists.`);
  } catch (error) {
    if (error.name === 'NotFound') {
      // Bucket does not exist, create it
      try {
        await s3.send(new CreateBucketCommand({ Bucket: bucketName }));
        console.log(`Bucket "${bucketName}" created successfully.`);
      } catch (createError) {
        console.error(`Error creating bucket "${bucketName}":`, createError);
      }
    } else {
      console.error(`Error checking bucket "${bucketName}":`, error);
    }
  }
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
export const getSignedUploadUrl = async ({ filename, fileType, type = 'avatar' }) => {
  if (!filename || !fileType) {
    throw new ApiError(400, 'S3', 'Filename and fileType are required.');
  }

  const key = `${type}/${filename}`;
  const contentType = fileType;

  const url = await getSignedUrl(s3, new PutObjectCommand({
    Bucket: AWS_S3_BUCKET,
    Key: key,
    ContentType: contentType,
  }));

  return { url, key };
};

export const allowedCategories = ['avatar', 'sign', 'post'];
export const allowedFileTypes = ['image/webp', 'image/jpeg', 'image/jpg', 'image/png'];
