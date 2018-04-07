#include "filehelper.h"

#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QUuid>
#include <QImage>
#include <QTransform>

/**
 * @brief The constructor initializes the picrures folder path field and creates the directory in
 * the system if it's not exists.
 * @param parent The parent QObject instance.
 */
FileHelper::FileHelper(QObject* parent) : QObject(parent) {
    picturesFolderPath = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation)
            + "/sailnotes/";
    if (!QDir(picturesFolderPath).exists()) QDir().mkdir(picturesFolderPath);
}

/**
 * @brief Generates the full path for saving a picture.
 * @param extension The picture file extension.
 * @return The full picture path.
 */
QString FileHelper::generatePictureFullPath(const QString& extension) {
    return picturesFolderPath + QUuid::createUuid().toString() + "." + extension;
}

/**
 * @brief Removes a file by the given path.
 * @param path The path of the file to remove.
 */
void FileHelper::removeFile(const QString& path) {
    QFile::remove(path);
}

/**
 * @brief Rotates a photo by the given path by 90 degrees.
 * @param photoPath The path of the photo to rotate.
 */
void FileHelper::rotatePhoto(const QString& photoPath) {
    QImage image(photoPath);
    QTransform rotation;
    rotation.rotate(90);
    QImage rotatedImage = image.transformed(rotation);
    rotatedImage.save(photoPath);
}
