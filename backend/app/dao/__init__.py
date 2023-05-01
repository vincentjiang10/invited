class DaoException(Exception):
    """
    General Dao exception raised when a dao operations fails
    """

    def __init__(self, message, code=400):
        self.message = message
        self.code = code
