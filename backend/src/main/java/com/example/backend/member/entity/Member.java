package com.example.backend.member.entity;

import com.example.backend.board.entity.Board;
import com.example.backend.security.entity.Authentication;
import com.example.backend.security.entity.BasicAuthentication;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.*;

@Entity
@Getter
@NoArgsConstructor
public class Member {
    @Id
    @Column(name = "member_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    @Column(nullable = false)
    private String email;

    @Setter
    @Column(nullable = false)
    private String nickname;

    @OneToMany(mappedBy = "member", fetch = FetchType.LAZY)
    private Set<Authentication> authentications = new HashSet<>();

    @OneToMany(mappedBy = "member", fetch = FetchType.LAZY)
    private List<Board> boards = new ArrayList<>();

    public Member(String email, String nickname) {
        this.email = email;
        this.nickname = nickname;
    }
    public void setBoard (Board board) {
        boards.add(board);
        board.setMember(this);
    }

    private Optional<Authentication> findBasicAuthentication() {
        return authentications
                .stream()
                .filter(auth -> auth instanceof BasicAuthentication)
                .findFirst();
    }

    public boolean isRightPassword(String plainToCheck) {
        final Optional<Authentication> maybeBasicAuth = findBasicAuthentication();

        if (maybeBasicAuth.isPresent()) {
            final BasicAuthentication auth = (BasicAuthentication) maybeBasicAuth.get();
            return auth.isRightPassword(plainToCheck);
        }

        return false;
    }

}


