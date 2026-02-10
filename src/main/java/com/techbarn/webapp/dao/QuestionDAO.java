package com.techbarn.webapp.dao;

import com.techbarn.webapp.ApplicationDB;
import com.techbarn.webapp.model.Question;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    private static Question map(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setQuestionId(rs.getInt("question_id"));
        q.setTitle(rs.getString("title"));
        q.setContents(rs.getString("contents"));
        q.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("date_asked");
        if (ts != null) q.setDateAsked(ts.toLocalDateTime());
        q.setUserId(rs.getInt("user_id"));
        q.setReply(rs.getString("reply"));
        int rep = rs.getInt("rep_id");
        q.setRepId(rs.wasNull() ? null : rep);
        return q;
    }

    public static List<Question> searchByKeyword(String keyword) {
        List<Question> out = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE title LIKE ? OR contents LIKE ? ORDER BY date_asked DESC";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k);
            ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) out.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return out;
    }

    public static List<Question> getAnswered() {
        List<Question> out = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE reply IS NOT NULL AND reply <> '' ORDER BY date_asked DESC";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return out;
    }

    public static List<Question> getOpen() {
        List<Question> out = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE reply IS NULL OR reply = '' ORDER BY date_asked DESC";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return out;
    }

    public static List<Question> getAllQuestions() {
        List<Question> out = new ArrayList<>();
        String sql = "SELECT * FROM Question ORDER BY date_asked DESC";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return out;
    }

    /** @throws SQLException if insert fails (e.g. column size, constraint) */
    public static void askQuestion(int userId, String title, String contents) throws SQLException {
        String sql = "INSERT INTO Question (title, contents, status, date_asked, user_id) VALUES (?, ?, 'open', NOW(), ?)";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, contents);
            ps.setInt(3, userId);
            ps.executeUpdate();
        }
    }

    public static List<Question> getQuestionsByUserId(int userId) {
        List<Question> out = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE user_id = ? ORDER BY date_asked DESC";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) out.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return out;
    }

    public static Question getById(int id) {
        String sql = "SELECT * FROM Question WHERE question_id = ?";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public static void answerQuestion(int questionId, int repId, String reply) {
        String sql = "UPDATE Question SET reply = ?, rep_id = ?, status = 'answered' WHERE question_id = ?";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, repId);
            ps.setInt(3, questionId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
