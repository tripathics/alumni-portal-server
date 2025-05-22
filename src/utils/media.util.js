const createTimestampedFileUrl = (filename) =>
  filename ? `${filename}?updated_at=${new Date().getTime()}` : null;

export const createTimestampedAvatarUrl = (filename) =>
  createTimestampedFileUrl(filename);

export const createTimestampedSignUrl = (filename) =>
  createTimestampedFileUrl(filename);

export const getS3Url = (filename, type) =>
  `https://${process.env.AWS_S3_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com/${type}/${filename}`;
