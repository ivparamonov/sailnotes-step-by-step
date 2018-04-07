#ifndef FILEHELPER_H
#define FILEHELPER_H

#include <QObject>

/*!
 * \brief The FileHelper class contains utility methods for generating pictures paths,
 * removing files and rotating photos.
 */
class FileHelper : public QObject {
    Q_OBJECT

public:
    explicit FileHelper(QObject* parent = NULL);

    Q_INVOKABLE QString generatePictureFullPath(const QString& extension = QString("png"));
    Q_INVOKABLE void removeFile(const QString& path);
    Q_INVOKABLE void rotatePhoto(const QString& photoPath);

private:
    QString picturesFolderPath;
};

#endif
